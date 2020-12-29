//
//  GameScene.swift
//  Sprite--用户交互
//
//  Created by targeter on 2019/3/1.
//  Copyright © 2019 targeter. All rights reserved.
//

import SpriteKit
import GameplayKit
import  AVFoundation

let planeCategory:UInt32 = 0x1<<0
let bulletCategory:UInt32 = 0x1<<1
let ufoCategory:UInt32 = 0x1<<2

class GameScene: SKScene,SKPhysicsContactDelegate {
    let duration:TimeInterval = 0.5
    
    var bullets: NSMutableArray = NSMutableArray(capacity: 5)
    var bulletSound : NSMutableArray = NSMutableArray(capacity: 5)
    var currentBullet: Int = 0
    //加载sks粒子配置文件
    var emitter:SKEmitterNode! = nil
    
    //发射器
    let shipNode: SKSpriteNode = SKSpriteNode(imageNamed: "sicongwang")
    //添加三个地面变量
    var floor1 = SKSpriteNode(imageNamed: "universal_01")
    var floor2 = SKSpriteNode(imageNamed: "universal_02")
    var floor3 = SKSpriteNode(imageNamed: "universal_03")
    
    var floor_temp:SKSpriteNode!
    var floors:NSMutableArray = NSMutableArray(capacity: 3)
    let bgmPlayer = Music()
    
    override func didMove(to view: SKView) {
        self.size = UIScreen.main.bounds.size
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        //设置背景
        setBackground()
        //背景移动
        move()
        //添加飞机
        addPlane()
        //飞机火焰
        openFire()
        //发射子弹
        shootBullet()
        //添加背景音乐
        bgmPlayer.playBGM()
        //随机添加障碍物
        randomCreateBarrier()
    }
    
    //MARK:添加飞机
    func addPlane() {
        //添加飞机
        shipNode.position = CGPoint(x: self.frame.midX, y: 50)
        shipNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shipNode.zPosition = 1.0
        self.addChild(shipNode)
    }
    
    //MARK:添加背景图
    func setBackground() {
        floors.add(floor1)
        floors.add(floor2)
        floors.add(floor3)
        for i in 0..<floors.count {
            let floor:SKSpriteNode = floors[i] as! SKSpriteNode
            floor.position = CGPoint(x: 0, y: CGFloat(i) * self.frame.height)
            floor.anchorPoint = CGPoint.zero
            floor.size = self.frame.size
        }
        self.addChild(floor1)
        self.addChild(floor2)
        self.addChild(floor3)
    }
    
    //MARK:背景滚动
    func move() {
        let moveAct = SKAction.wait(forDuration: 0.02)
        let generateAct = SKAction.run {
            self.moveScene()
        }
        run(SKAction.repeatForever(SKAction.sequence([moveAct,generateAct])), withKey: "move")
    }
    //MARK:滚动
    func moveScene() {
        //floor move
        floor1.position = CGPoint(x: 0, y: floor1.position.y - 1)
        floor2.position = CGPoint(x: 0, y: floor2.position.y - 1)
        floor3.position = CGPoint(x: 0, y: floor3.position.y - 1)
        //check floor
        let height_pad = self.frame.size.height
        if floor1.position.y < -height_pad {
            floor1.position.y = floor3.position.y + height_pad
        }
        if floor2.position.y < -height_pad {
            floor2.position.y = floor1.position.y + height_pad
        }
        if floor3.position.y < -height_pad {
            floor3.position.y = floor2.position.y + height_pad
        }
        
    }
    
    
    //MARK:发射子弹
    func shootBullet() {
        //每隔1秒
        let waitAction = SKAction.wait(forDuration: 0.7)
        //创建一个子弹
        let createBulletAction = SKAction.run {
            let bullet = SKSpriteNode(imageNamed: "hotdog")
            bullet.position = self.shipNode.position
            bullet.name = "bullet"
            bullet.zPosition = 1.0
            bullet.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: bullet.size.width, height: bullet.size.height))
            bullet.physicsBody?.categoryBitMask = 2
            bullet.physicsBody?.contactTestBitMask = 1
            self.addChild(bullet)
            
            //发射子弹
            let fireAction = SKAction.move(to: CGPoint(x: self.shipNode.position.x, y: self.frame.size.height), duration: 1.5)
            
            let bulletSound = Music()
            //触发射击音效
            let shootSound = SKAction.run {
                bulletSound.bulletShootSound()
            }
            
            let createAndSound = SKAction.group([fireAction,shootSound])
            //子弹离开屏幕消失
            let endAction = SKAction.run {
                bullet.removeFromParent()
            }
            //动作组合
            let fireSequence = SKAction.sequence([createAndSound,endAction])
            bullet.run(fireSequence)
            
        }
        run(SKAction.repeatForever(SKAction.sequence([createBulletAction,waitAction])))
    }
    
    //MARK:飞机操作---开始触摸
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取当前点击点的坐标
        let touches = touches as NSSet
        let touch = touches.anyObject() as AnyObject
        let locationPoint = touch.location(in:self)
        //将飞机移动到点击点
        //创建移动事件
        let newDuration = Double(abs(shipNode.position.x - locationPoint.x)/self.frame.midX) * duration
        let targetPoint = CGPoint(x: locationPoint.x, y: shipNode.position.y)
        let shipMove = SKAction.move(to: targetPoint, duration: newDuration)
        let fireMove = SKAction.move(to: CGPoint(x: targetPoint.x, y: targetPoint.y - 20), duration: newDuration)
        shipNode.run(shipMove)
        emitter.run(fireMove)
    }
    
    //MARK:飞机操作---结束触摸
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        shipNode.removeAllActions()
        emitter.removeAllActions()
    }
    
    
    //MARK:飞机火焰
    func openFire() {
        //添加火焰
        let burstPath = Bundle.main.path(forResource: "Spark", ofType: "sks")
        self.emitter = NSKeyedUnarchiver.unarchiveObject(withFile: burstPath!) as? SKEmitterNode
        self.emitter.position = CGPoint(x: self.frame.midX, y: shipNode.position.y - 20)
        self.addChild(self.emitter)
    }
    
    //MARK:爆炸效果
    func explode(point:CGPoint) {
        let explodeAtlas = SKTextureAtlas.init(named: "exploded")
        let allTextureArray = NSMutableArray.init(capacity: 16)
        for i in 0..<explodeAtlas.textureNames.count {
            let textureName = String(format: "%d@2x.png", arguments: [i+1])
            let texture = explodeAtlas.textureNamed(textureName)
            allTextureArray.add(texture)
        }
        let bombNode = SKSpriteNode(texture: allTextureArray[0] as? SKTexture)
        bombNode.position = point
        bombNode.name = "bomb"
        bombNode.size = CGSize(width: 50, height: 50)
        bombNode.zPosition = 2.0
        self.addChild(bombNode)
        
        //爆炸效果动画
        let animationAction = SKAction.animate(with: allTextureArray as! [SKTexture], timePerFrame: 0.05)
        let sound = Music()
        let soundAction = SKAction.run {
            sound.bomb()
        }
        bombNode.run(SKAction.group([animationAction,soundAction])) {
            bombNode.removeFromParent()
        }
    }
    
    
    //MARK:随机位置(x方向)落下障碍物
    func addBarriers() {
        let barrier = SKSpriteNode(imageNamed: "UFO")
        barrier.name = "barrier"
        let x_value:CGFloat = CGFloat(arc4random_uniform(UInt32(self.frame.size.width)))
        let y_value:CGFloat = self.frame.size.height + 50
        barrier.position = CGPoint(x: x_value, y: y_value)
        barrier.zPosition = 1.0
        barrier.physicsBody = SKPhysicsBody(rectangleOf: barrier.frame.size)
        barrier.physicsBody?.categoryBitMask = 1
        barrier.physicsBody?.affectedByGravity = false
        barrier.physicsBody?.contactTestBitMask = 2
        self.addChild(barrier)
        barrier.run(SKAction.moveTo(y: 0, duration: 8.0)) {
            barrier.removeAllActions()
            barrier.removeFromParent()
        }
    }
    
    //MARK:创建随机定时
    func randomCreateBarrier() {
        let waitAct = SKAction.wait(forDuration: 2, withRange: 1.0)
        let generateAct = SKAction.run {
            self.addBarriers()
        }
        //等待-创建-等待-创建
        run(SKAction.repeatForever(SKAction.sequence([generateAct,waitAct])))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

//MARK:配置场景的物理体代理
extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact)  {
        //为方便我们判断碰撞的bodyA和bodyB的cateBitMask哪个小，小的则将它保存在新建的变脸bodyA里，大的则保存到新建d变量bodyB里
        var bodyA:SKPhysicsBody
        var bodyB:SKPhysicsBody
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        } else {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        //判断bodyA是否为子弹，bodyB是否为飞碟，如果是则游戏结束，直接调用爆炸方法
        if (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1) {
            //在飞碟的位置爆炸
            explode(point: (bodyB.node?.position)!)
            bodyB.node?.removeFromParent()
            bodyA.node?.removeFromParent()
            
        }
    }
    
}
