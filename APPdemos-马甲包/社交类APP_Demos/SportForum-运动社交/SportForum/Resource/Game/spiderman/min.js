function main() {
 var d = {
  isShowClue1: !0,
  isFirstInGame: !0,
  init: function() {
   jsGame.canvas.screen.setWidth(d.width);
   jsGame.canvas.screen.setHeight(d.height);
   d.width < d.height && (d.clue = !0);
   300 <= d.height ? d.isShowClue1 = !1 : d.isFirstInGame && (d.isFirstInGame = !1, d.isShowClue1 = !0)
  },
  initCanvas: function() {
   jsGame.canvas.screen.getTouch() ? (window.scrollTo(0, -5), d.height = 800, d.width = 480, jsGame.canvas.screen.setHeight(d.height), d.top = 0, d.left = 0) : (d.height = 800, d.width = 480, jsGame.canvas.screen.setHeight(d.height), jsGame.canvas.screen.setWidth(d.width), d.top = 0, d.left = (window.innerWidth - d.width) / 2);
   d.init();
   d.canvas = document.getElementById("jsGameScreen");
   d.ctx = d.canvas.getContext("2d")
  }
 };
 d.initCanvas();
 jsGame.initImage([{
  id: "a",
  src: "img/a.png"
 }, {
  id: "h",
  src: "img/h.png"
 }, {
  id: "chinese",
  src: "img/chinese.png"
 }, {
  id: "english",
  src: "img/english.png"
 }, {
  id: "logo",
  src: "img/logo.png?d"
 }, {
  id: "bg",
  src: "img/bg_240.png"
 }, {
  id: "cd",
  src: "img/cd.png"
 }, {
  id: "num",
  src: "img/num.png"
 }, {
  id: "dm",
  src: "img/dm.png"
 }, {
  id: "jiafen",
  src: "img/jiafen.png"
 }, {
  id: "jiafenE",
  src: "img/jiafenE.png"
 }, {
  id: "jiantou",
  src: "img/jiantou.png"
 }, {
  id: "life_1",
  src: "img/life_1.png"
 }, {
  id: "life_2",
  src: "img/life_2.png"
 }, {
  id: "ren",
  src: "img/ren.png"
 }, {
  id: "shengzixiaoguo",
  src: "img/shengzixiaoguo.png"
 }, {
  id: "tishi_1",
  src: "img/tishi_1.png"
 }, {
  id: "tishi_1E",
  src: "img/tishi_1E.png"
 }, {
  id: "zhuzi_y",
  src: "img/zhuzi_y.png"
 }, {
  id: "http://web10.916d.com/games/mingxuanyixian",
  src: "img/zhuzi_z.png"
 }, {
  id: "notice",
  src: "img/notice.png"
 }, {
  id: "noticeE",
  src: "img/noticeE.png"
 }, {
  id: "han1",
  src: "img/img036.png"
 }, {
  id: "han2",
  src: "img/img037.png"
 }, {
  id: "mingzhong",
  src: "img/mingzhong.png"
 }, {
  id: "start",
  src: "img/start.png"
 }, {
  id: "startE",
  src: "img/start.png"
 }, {
  id: "more",
  src: "img/more.png?d"
 }, {
  id: "moreE",
  src: "img/more.png"
 }, {
  id: "back",
  src: "img/back.png?dd"
 }, {
  id: "backE",
  src: "img/back.png"
 }, {
  id: "retry",
  src: "img/retry.png"
 }, {
  id: "retryE",
  src: "img/retry.png"
 }, {
  id: "isexit",
  src: "img/isexit.png"
 }, {
  id: "isexitE",
  src: "img/isexit.png"
 }, {
  id: "intro",
  src: "img/intro.png"
 }, {
  id: "score",
  src: "img/score.png"
 }, {
  id: "scoreE",
  src: "img/score.png"
 }, {
  id: "Hscore",
  src: "img/Hscore.png"
 }, {
  id: "HscoreE",
  src: "img/Hscore.png"
 }, {
  id: "zz",
  src: "img/zz.png"
 }]);
 jsGame.initImageCallBack(function(b, N) {
  if (b >= N) jsGame.gameFlow.run();
  else
  try {
   var G = b / N,
       G = 1 < G ? 1 : G;
   d.ctx.fillStyle = "#FFFFFF";
   d.ctx.fillRect(0, 0, d.width, d.height);
   d.ctx.drawImage(jsGame.getImage("a"), 0, 0, 250, 81, (d.width - 250) / 2, (d.height - 81) / 2, 250, 81);
   d.ctx.drawImage(jsGame.getImage("a"), 2, 86, 246 * G, 10, (d.width - 246) / 2, (d.height - 81) / 2 + 51, 246 * G, 10)
  } catch (D) {}
 });
 jsGame.pageLoad(function(b) {
  var N, G;

  function D(a, c, f, d, h, l, k, g, p, q) {
   b.canvas.drawImage(a, c * d, f * h, d, h, l, k, g, p, q)
  }
  function r(a, b, c) {
   return b > a.x && c > a.y && b < a.x + a.w && c < a.y + a.h ? !0 : !1
  }
  function sa(e) {
   g == T ? r(s, e.x, e.y) ? s.isPressed = !0 : r(u, e.x, e.y) && (u.isPressed = !0) : g == H ? r(p, e.x, e.y) ? p.isPressed = !0 : r(q, e.x, e.y) && (q.isPressed = !0) : g == ca ? (ta(), g = U) : g == U ? r(I, e.x, e.y) ? g = da : a.state == c.renStateType.swinging && v(c.renStateType.flying) : g == O ? r(m, e.x, e.y) ? m.isPressed = !0 : r(n, e.x, e.y) && dp_share(x) && (n.isPressed = !0) : g == da && (r(Aa, e.x, e.y) ? g = H : r(Ba, e.x, e.y) && (g = U))
  }
  function ua(a) {
   g == T ? (r(s, a.x, a.y) || (s.isPressed = !1), r(u, a.x, a.y) || (u.isPressed = !1)) : g == H ? (r(p, a.x, a.y) || (p.isPressed = !1), r(q, a.x, a.y) || (q.isPressed = !1)) : g == O && (r(m, a.x, a.y) || (m.isPressed = !1), r(n, a.x, a.y) || (n.isPressed = !1))
  }
  function va(a) {
   g == T ? s.isPressed && r(s, a.x, a.y) ? (g = H, w = "CHS", b.localStorage.setItem("language", w), s.isPressed = !1) : u.isPressed && r(u, a.x, a.y) && (g = H, w = "ENG", b.localStorage.setItem("language", w), u.isPressed = !1) : g == H ? p.isPressed && r(p, a.x, a.y) ? (g = ca, p.isPressed = !1) : q.isPressed && r(q, a.x, a.y) && (dp_Ranking(), q.isPressed = !1) : g == O && (m.isPressed && r(m, a.x, a.y) ? (ta(), g = U, m.isPressed = !1) : n.isPressed && r(n, a.x, a.y) && (g = H, n.isPressed = !1))
  }
  d.showClue = function() {
   window.scrollTo(0, -5);
   d.ctx.fillStyle = "#ffffff";
   d.ctx.fillRect(0, 0, window.innerWidth, window.innerHeight);
   b.canvas.drawImage("h", (window.innerWidth - 153) / 2, (window.innerHeight - 122) / 2)
  };
  var s = {
   x: (b.canvas.screen.getWidth() - 126) / 2,
   y: 180,
   w: 126,
   h: 35,
   isPressed: !1,
   draw: D
  },
      u = {
    x: (b.canvas.screen.getWidth() - 126) / 2,
    y: 260,
    w: 126,
    h: 35,
    isPressed: !1,
    draw: D
      },
      p = {
    x: (b.canvas.screen.getWidth() - 126) / 2,
    y: 480,
    w: 126,
    h: 35,
    isPressed: !1,
    draw: D
      },
      q = {
    x: (b.canvas.screen.getWidth() - 126) / 2,
    y: 460,
    w: 126,
    h: 35,
    isPressed: !1,
    draw: D
      },
      I = {
    x: 5,
    y: b.canvas.screen.getHeight() + 100,
    w: 49,
    h: 22,
    isPressed: 0,
    draw: D
      },
      Aa = {
    x: 165,
    y: 300,
    w: 75,
    h: 70,
    isPressed: !1,
    draw: D
      },
      Ba = {
    x: 240,
    y: 300,
    w: 75,
    h: 70,
    isPressed: !1,
    draw: D
      },
      m = {
    x: (b.canvas.screen.getWidth() - 126) / 2,
    y: 380,
    w: 126,
    h: 35,
    isPressed: !1,
    draw: D
      },
      n = {
    x: (b.canvas.screen.getWidth() - 126) / 2,
    y: 460,
    w: 126,
    h: 35,
    isPressed: !1,
    draw: D
      },
      c = {
    stateType: {
     ready: 0,
     start: 1,
     over: 2
    },
    renStateType: {
     standing: 0,
     moving: 1,
     throwing: 2,
     startSwinging: 3,
     swinging: 4,
     flying: 5,
     landing: 6,
     anxiousLeft: 7,
     anxiousRight: 8,
     crashing: 9,
     reactivating: 10
    },
    lineStateType: {
     holding: 0,
     shooting: 1,
     startSwinging: 2,
     swinging: 3,
     flying: 4
    }
      },
      l = {
    frames: [{
     i: 0,
     sx: 12,
     sy: 1,
     width: 20,
     height: 32,
     dx: 0,
     dy: 0,
     ssx: 0,
     ssy: 0
    }, {
     i: 1,
     sx: 53,
     sy: 0,
     width: 20,
     height: 33,
     dx: 0,
     dy: 0,
     ssx: 0,
     ssy: 0
    }, {
     i: 2,
     sx: 94,
     sy: 1,
     width: 20,
     height: 32,
     dx: 0,
     dy: 1,
     ssx: 0,
     ssy: 0
    }, {
     i: 3,
     sx: 135,
     sy: 3,
     width: 20,
     height: 30,
     dx: 0,
     dy: 2,
     ssx: 0,
     ssy: 0
    }, {
     i: 4,
     sx: 177,
     sy: 3,
     width: 21,
     height: 30,
     dx: 0,
     dy: 4,
     ssx: 0,
     ssy: 0
    }, {
     i: 5,
     sx: 219,
     sy: 3,
     width: 22,
     height: 30,
     dx: 2,
     dy: 4,
     ssx: 0,
     ssy: 0
    }, {
     i: 6,
     sx: 14,
     sy: 46,
     width: 24,
     height: 28,
     dx: 3,
     dy: 4,
     ssx: 0,
     ssy: 0
    }, {
     i: 7,
     sx: 45,
     sy: 49,
     width: 23,
     height: 25,
     dx: -8,
     dy: 7,
     ssx: 0,
     ssy: 0
    }, {
     i: 8,
     sx: 86,
     sy: 49,
     width: 23,
     height: 25,
     dx: -8,
     dy: 7,
     ssx: 0,
     ssy: 0
    }, {
     i: 9,
     sx: 214,
     sy: 46,
     width: 20,
     height: 28,
     dx: 2,
     dy: 5,
     ssx: 6,
     ssy: 14
    }, {
     i: 10,
     sx: 173,
     sy: 44,
     width: 20,
     height: 30,
     dx: 2,
     dy: 3,
     ssx: 6,
     ssy: 16
    }, {
     i: 11,
     sx: 132,
     sy: 42,
     width: 20,
     height: 32,
     dx: 2,
     dy: 1,
     ssx: 8,
     ssy: 16
    }, {
     i: 12,
     sx: 12,
     sy: 85,
     width: 20,
     height: 33,
     dx: 0,
     dy: 0,
     ssx: 1,
     ssy: 16
    }, {
     i: 13,
     sx: 53,
     sy: 81,
     width: 20,
     height: 36,
     dx: 0,
     dy: 0,
     ssx: 1,
     ssy: 18
    }, {
     i: 14,
     sx: 95,
     sy: 88,
     width: 20,
     height: 33,
     dx: 0,
     dy: 0,
     ssx: 1,
     ssy: 15
    }, {
     i: 15,
     sx: 136,
     sy: 90,
     width: 21,
     height: 32,
     dx: -1,
     dy: 0,
     ssx: -1,
     ssy: 15
    }, {
     i: 16,
     sx: 176,
     sy: 91,
     width: 22,
     height: 31,
     dx: -1,
     dy: -1,
     ssx: 1,
     ssy: 11
    }, {
     i: 17,
     sx: 215,
     sy: 92,
     width: 24,
     height: 31,
     dx: -2,
     dy: -1,
     ssx: 1,
     ssy: 10
    }, {
     i: 18,
     sx: 5,
     sy: 133,
     width: 29,
     height: 27,
     dx: -5,
     dy: -3,
     ssx: 2,
     ssy: 8
    }, {
     i: 19,
     sx: 41,
     sy: 133,
     width: 34,
     height: 22,
     dx: -7,
     dy: -5,
     ssx: 5,
     ssy: 5
    }, {
     i: 20,
     sx: 85,
     sy: 133,
     width: 31,
     height: 20,
     dx: -6,
     dy: -6,
     ssx: 6,
     ssy: 4
    }, {
     i: 21,
     sx: 126,
     sy: 133,
     width: 31,
     height: 20,
     dx: -6,
     dy: -6,
     ssx: 7,
     ssy: 4
    }, {
     i: 22,
     sx: 164,
     sy: 133,
     width: 34,
     height: 22,
     dx: -7,
     dy: -5,
     ssx: 0,
     ssy: 0
    }, {
     i: 23,
     sx: 210,
     sy: 133,
     width: 29,
     height: 27,
     dx: -5,
     dy: -3,
     ssx: 0,
     ssy: 0
    }, {
     i: 24,
     sx: 7,
     sy: 173,
     width: 27,
     height: 30,
     dx: -4,
     dy: -1,
     ssx: 0,
     ssy: 0
    }, {
     i: 25,
     sx: 51,
     sy: 170,
     width: 23,
     height: 34,
     dx: -2,
     dy: 1,
     ssx: 0,
     ssy: 0
    }, {
     i: 26,
     sx: 95,
     sy: 170,
     width: 20,
     height: 34,
     dx: 0,
     dy: 1,
     ssx: 0,
     ssy: 0
    }, {
     i: 27,
     sx: 135,
     sy: 168,
     width: 20,
     height: 34,
     dx: 0,
     dy: 1,
     ssx: 0,
     ssy: 0
    }, {
     i: 28,
     sx: 178,
     sy: 164,
     width: 20,
     height: 32,
     dx: 0,
     dy: 0,
     ssx: 0,
     ssy: 0
    }, {
     i: 29,
     sx: 217,
     sy: 167,
     width: 20,
     height: 30,
     dx: 0,
     dy: 1,
     ssx: 0,
     ssy: 0
    }, {
     i: 30,
     sx: 12,
     sy: 207,
     width: 20,
     height: 31,
     dx: 0,
     dy: 1,
     ssx: 0,
     ssy: 0
    }, {
     i: 31,
     sx: 55,
     sy: 207,
     width: 20,
     height: 31,
     dx: 0,
     dy: 2,
     ssx: 0,
     ssy: 0
    }, {
     i: 32,
     sx: 94,
     sy: 207,
     width: 20,
     height: 31,
     dx: -2,
     dy: 1,
     ssx: 0,
     ssy: 0
    }, {
     i: 33,
     sx: 132,
     sy: 209,
     width: 20,
     height: 29,
     dx: 0,
     dy: 2,
     ssx: 0,
     ssy: 0
    }, {
     i: 34,
     sx: 175,
     sy: 207,
     width: 20,
     height: 31,
     dx: 2,
     dy: 1,
     ssx: 0,
     ssy: 0
    }, {
     i: 35,
     sx: 0,
     sy: 0,
     width: 1,
     height: 1,
     dx: 0,
     dy: 0,
     ssx: 0,
     ssy: 0
    }],
    gSpeed: 0,
    sSpeed: 0,
    mapMovingPath: []
      },
      a = {
    state: c.renStateType.standing,
    width: 20,
    height: 32,
    x: 0,
    y: 0,
    stepX: 0,
    stepY: 0,
    animateStep: 0,
    frameIndexs: [],
    tiles: [
     [0],
     [1, 1, 2, 2, 3, 3],
     [0, 4, 5, 6, 7, 8],
     [9, 9, 9, 10, 10, 10, 11, 11, 11],
     [12, 12, 12, 13, 13, 13, 14, 14, 14, 15, 15, 15, 16, 16, 16, 17, 17, 17, 18, 18, 18, 19, 19, 19, 20, 20, 20, 21, 21, 21],
     [28],
     [29, 30, 30, 30, 30],
     [31, 32, 31, 32, 31, 32, 31, 32, 31, 32, 31, 32, 31, 32],
     [33, 34, 33, 34, 33, 34, 33, 34, 33, 34, 33, 34, 33, 34],
     [],
     [0, 35, 0, 35, 0, 35, 0, 35, 0, 35, 0, 35, 0, 35, 0, 35, 0]
    ],
    swingPath: [],
    swingAnimateIndex: 0,
    swingFront: !0,
    speed: 0,
    aSpeed: 0,
    flyingPath: [],
    movingPath: [],
    life: 0,
    continualHit: 0
      },
      ea = function(b, c, f) {
    a.x = b;
    a.y = c;
    a.stepX = 0;
    a.stepY = 0;
    a.animateStep = 0;
    a.frameIndexs = [];
    a.swingPath = [];
    a.swingAnimateIndex =
    0;
    a.swingFront = !0;
    a.speed = 5;
    a.aSpeed = 0;
    a.flyingPath = [];
    a.movingPath = [];
    a.life = 1
      },
      E = 0,
      wa = function(a, c) {
    6 > E ? (b.canvas.drawImage("han1", 20 * parseInt(E), 0, 20, 17, a + 10, c - 5, 40, 34), E += 0.5) : 12 > E && (b.canvas.drawImage("han2", 20 * parseInt(E - 6), 0, 20, 17, a - 10, c - 5, 40, 34), E += 0.5, E %= 12)
      },
      k, J, fa, ga, Y = [],
      L, v = function(e) {
    switch (e) {
    case c.renStateType.standing:
     a.state = c.renStateType.standing;
     break;
    case c.renStateType.throwing:
     a.state = c.renStateType.throwing;
     a.frameIndexs = b.clone(a.tiles[c.renStateType.throwing]);
     break;
    case c.renStateType.startSwinging:
     a.state =
     c.renStateType.startSwinging;
     a.frameIndexs = b.clone(a.tiles[c.renStateType.startSwinging]);
     break;
    case c.renStateType.swinging:
     a.state = c.renStateType.swinging;
     e = a;
     for (var d = a.x - h.rootX, k = a.y - h.rootY, g = a.tiles[c.renStateType.swinging].length, p = [], q = Math.sqrt(d * d + k * k), d = 180 * Math.atan(Math.abs(d / k)) / Math.PI, k = 2 * d / g, m, n, r = 0; r < g; r++) m = d - k / 2 - k * r, n = m * Math.PI / 180, m = Math.sin(n) * q, n = Math.cos(n) * q, p.push({
      x: m,
      y: n
     });
     e.swingPath = p;
     break;
    case c.renStateType.flying:
     a.state = c.renStateType.flying;
     a.aSpeed = 0;
     e = a.y - h.rootY;
     g = a.x - h.rootX;
     Math.sqrt(e * e + g * g);
     g = 180 * Math.atan(e / g) / Math.PI;
     a.speed = a.swingFront ? a.speed * Math.abs(g / 90) : -0.5;
     e = a;
     r = l.g * (1 - Math.abs(g / 90)) * (g / Math.abs(g)) - 5;
     m = a.x;
     g = a.y;
     k = m;
     p = g;
     q = [];
     d = -a.speed;
     q.push({
      x: m,
      y: g
     });
     for (var s, u = 0; 100 > u && !(m = d, n = r + 1, k += m, s = p + n, d = m, r = n, p = s, q.push({
      x: k,
      y: p,
      stepX: m,
      stepY: n
     }), s >= g); u++);
     e.flyingPath = q;
     break;
    case c.renStateType.landing:
     a.state = c.renStateType.landing;
     a.x <= f.tiles[1].x - 8 ? v(c.renStateType.anxiousLeft) : a.x >= f.tiles[1].x + f.tiles[1].width - 10 ? v(c.renStateType.anxiousRight) : a.frameIndexs = b.clone(a.tiles[c.renStateType.landing]);
     break;
    case c.renStateType.crashing:
     a.state = c.renStateType.crashing;
     break;
    case c.renStateType.anxiousLeft:
     a.state = c.renStateType.anxiousLeft;
     a.frameIndexs = b.clone(a.tiles[c.renStateType.anxiousLeft]);
     break;
    case c.renStateType.anxiousRight:
     a.state = c.renStateType.anxiousRight;
     a.frameIndexs = b.clone(a.tiles[c.renStateType.anxiousRight]);
     break;
    case c.renStateType.moving:
     a.state = c.renStateType.moving;
     a.movingPath = [];
     L = 0;
     if (a.x > f.tiles[1].x) for (e = a.x; e >= f.tiles[1].x - 2; e -= 2) a.movingPath.push({
      x: e,
      frame: l.frames[a.tiles[c.renStateType.moving][L++]]
     }), L %= a.tiles[c.renStateType.moving].length;
     else
     for (e = a.x; e <= f.tiles[1].x - 2; e += 2) a.movingPath.push({
      x: e,
      frame: l.frames[a.tiles[c.renStateType.moving][L++]]
     }), L %= a.tiles[c.renStateType.moving].length;
     g = (b.canvas.screen.getWidth() - f.tiles[1].width - 10 - f.tiles[1].x) / 10;
     for (e = 0; 10 > e; e++) l.mapMovingPath.push({
      x: g,
      y: -parseInt(g / 2)
     });
     break;
    case c.renStateType.reactivating:
     ha(), ea(f.tiles[2].x, f.tiles[2].y - a.height, a.life), a.state = c.renStateType.reactivating, a.frameIndexs = b.clone(a.tiles[c.renStateType.reactivating])
    }
      },
      Z = function(a, c, d) {
    this.x = a;
    this.width = c;
    this.height = d + 200;
    this.y = b.canvas.screen.getHeight() - this.height;
    this.render = function() {
     b.canvas.drawImage("dm", parseInt((240 - this.width) / 2), 1, this.width, 5, this.x + 10, this.y + 32, this.width, 5).fillStyle("#8a9bbd").fillRect(this.x + 10, this.y + 5 + 32, this.width, this.height - 5)
    }
      },
      f = {
    tiles: [],
    current: {
     x: 0,
     y: 0,
     width: 0,
     height: 0
    }
      },
      P, ia, h = {
    rootX: -1,
    rootY: -1,
    fromX: -1,
    fromY: -1,
    animateFrames: [],
    lineAnimateStepNum: 3,
    effectFrames: []
      },
      ha = function() {
    h.fromX = -1;
    h.fromY = -1;
    h.rootX = -1;
    h.rootY = -1
      },
      ja, xa, V, K = function() {
    0 < a.swingPath.length && (J = a.swingPath[a.swingAnimateIndex], h.fromX = h.rootX + J.x, h.fromY = h.rootY + J.y, a.swingFront ? (a.swingAnimateIndex++, a.swingAnimateIndex >= a.swingPath.length && (a.swingAnimateIndex = a.swingPath.length - 1, a.swingFront = !1)) : (a.swingAnimateIndex--, 0 > a.swingAnimateIndex && (a.swingAnimateIndex = 0, ha(), a.swingPath = [], a.swingFront = !0)))
      },
      W = [],
      z, Q = 0,
      R = 0,
      A = 0,
      B = 0,
      S = [],
      ka = !1,
      la = function() {
    ka || (ka = !0, a.x <= f.tiles[1].x - 8 || a.x >= f.tiles[1].x + f.tiles[1].width - 10 ? (A = 189, B = 35, z = 25, a.continualHit = 0) : a.x <= f.tiles[1].x - 6 || a.x >= f.tiles[1].x + f.tiles[1].width - 12 ? (A = 126, B = 35, z = 50, a.continualHit = 0) : b.commandFuns.collisionCheck(a.x + 10, a.y + 5, k.width - 20, k.height, f.tiles[1].x + parseInt((f.tiles[1].width - 6) / 2), f.tiles[1].y, 6, 5) ? (B = A = 0, z = 1E3, W = [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], a.continualHit++) : (b.commandFuns.collisionCheck(a.x + 10, a.y + 5, k.width - 20, k.height, f.tiles[1].x + parseInt((f.tiles[1].width - 8) / 2), f.tiles[1].y, 8, 5) ? (A = 63, B = 0, z = 500) : b.commandFuns.collisionCheck(a.x + 10, a.y + 5, k.width - 20, k.height, f.tiles[1].x + parseInt((f.tiles[1].width - 12) / 2), f.tiles[1].y, 12, 5) ? (A = 126, B = 0, z = 500) : b.commandFuns.collisionCheck(a.x + 10, a.y + 5, k.width - 20, k.height, f.tiles[1].x + parseInt((f.tiles[1].width - 36) / 2), f.tiles[1].y, 36, 5) ? (A = 189, B = 0, z = 250) : b.commandFuns.collisionCheck(a.x + 10, a.y + 5, k.width - 20, k.height, f.tiles[1].x + parseInt((f.tiles[1].width - 80) / 2), f.tiles[1].y, 80, 5) ? (A = 0, B = 35, z = 100) : (A = 63, B = 35, z = 50), a.continualHit = 0));
    0 == W.length && 0 == S.length && (M++, Q = a.x, R = a.y - 30, S = [{
     y: -4
    }, {
     y: -2
    }, {
     y: -0
    }, {
     y: 2
    }, {
     y: 0
    }, {
     y: -2
    }, {
     y: 0
    }, {
     y: 2
    }, {
     y: 0
    }, {
     y: -2
    }, {
     y: 0
    }, {
     y: 0
    }, {
     y: 0
    }, {
     y: 0
    }, {
     y: 0
    }], v(c.renStateType.moving), ka = !1)
      },
      X, F, ma = !1,
      na = [],
      ya, za = function() {
    switch (a.state) {
    case c.renStateType.standing:
     K();
     k = l.frames[0];
     break;
    case c.renStateType.throwing:
     if (0 < a.frameIndexs.length) k = l.frames[a.frameIndexs.shift()];
     else {
      var e = a.x - 5,
          d = a.y + 10;
      if (3 == f.tiles.length && 0 == h.animateFrames.length) {
       ja = c.lineStateType.shooting;
       N = parseInt((f.tiles[2].x - (f.tiles[1].x + f.tiles[1].width)) / 2);
       G = d;
       for (var g = 0; g < h.lineAnimateStepNum; g++) h.animateFrames.push({
        fx: e,
        fy: d,
        tx: parseInt(e - (g + 1) * N / h.lineAnimateStepNum),
        ty: parseInt(d - (g + 1) * G / h.lineAnimateStepNum)
       })
      }
      a.state = -1
     }
     break;
    case c.renStateType.startSwinging:
     0 < a.frameIndexs.length ? (k = l.frames[a.frameIndexs.shift()], h.fromX = a.x + k.ssx, h.fromY = a.y + k.ssy, a.x += 3, a.y -= 3) : v(c.renStateType.swinging);
     break;
    case c.renStateType.swinging:
     0 < a.swingPath.length && (J = a.swingPath[a.swingAnimateIndex], k = l.frames[a.tiles[c.renStateType.swinging][a.swingAnimateIndex]], a.x = h.rootX + J.x, a.y = h.rootY + J.y, h.fromX = a.x + k.ssx, h.fromY = a.y + k.ssy, a.stepX = J.x, a.stepY = J.y, a.swingFront ? (a.swingAnimateIndex++, a.swingAnimateIndex >= a.swingPath.length && (a.swingAnimateIndex = a.swingPath.length - 1, a.swingFront = !1)) : (a.swingAnimateIndex--, 0 > a.swingAnimateIndex && (a.swingAnimateIndex = 0, a.swingFront = !0)));
     b.keyPressed("a") && v(c.renStateType.flying);
     break;
    case c.renStateType.flying:
     K();
     k = l.frames[a.tiles[c.renStateType.flying][0]];
     0 < a.flyingPath.length ? (fa = a.flyingPath.shift(), a.x = fa.x, a.y = fa.y) : (a.x -= a.speed + l.sSpeed, a.y += l.g + l.gSpeed + a.aSpeed, a.aSpeed += 0.2);
     b.commandFuns.collisionCheck(a.x + 5, a.y, k.width - 10, k.height + l.g + l.gSpeed + a.aSpeed - 0.2, f.tiles[1].x, f.tiles[1].y, f.tiles[1].width, f.tiles[1].height) ? a.y + k.height <= f.tiles[1].y + l.g - l.gSpeed ? (a.y = f.tiles[1].y - k.height, v(c.renStateType.landing)) : (a.x = f.tiles[1].x + f.tiles[1].width - 5, v(c.renStateType.crashing)) : a.y > b.canvas.screen.getHeight() + 100 && v(c.renStateType.crashing);
     break;
    case c.renStateType.landing:
     K();
     0 < a.frameIndexs.length ? k = l.frames[a.frameIndexs.shift()] : la();
     break;
    case c.renStateType.crashing:
     K();
     0 < a.y && (a.y += l.g + l.gSpeed);
     a.y > b.canvas.screen.getHeight() + 100 && (a.y = -100, Y = [0, 1, 2, 3, 4], a.life--, 0 < a.life ? 0 < a.life && v(c.renStateType.reactivating) : $ = c.stateType.over);
     break;
    case c.renStateType.anxiousLeft:
     K();
     wa(a.x, a.y);
     0 < a.frameIndexs.length ? k = l.frames[a.frameIndexs.shift()] : la();
     break;
    case c.renStateType.anxiousRight:
     K();
     wa(a.x, a.y);
     0 < a.frameIndexs.length ? k =
     l.frames[a.frameIndexs.shift()] : la();
     break;
    case c.renStateType.moving:
     K();
     if (0 < a.movingPath.length) ga = a.movingPath.shift(), k = ga.frame, a.x = ga.x;
     else if (0 == S.length) if (0 < l.mapMovingPath.length) for (F = l.mapMovingPath.shift(), a.x += F.x, h.fromX += F.x, h.rootX += F.x, 50 < f.tiles[1].y && (a.y += F.y, h.fromY += F.y, h.rootY += F.y), e = 0; e < f.tiles.length; e++) f.tiles[e].x += F.x, 50 < f.tiles[e].y && (f.tiles[e].y += F.y), f.tiles[e].height -= F.y;
     else 0 != M % 5 || ma || (ma = !0, l.gSpeed = b.commandFuns.getRandom(-5, 5), l.sSpeed = b.commandFuns.getRandom(-5, 5), 0 == l.gSpeed && 0 == l.sSpeed) || (na = [1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0]), 0 < na.length ? (ya = na.shift(), aa = 0 == ya ? !1 : !0) : (ma = !1, aa = !0, f.tiles.pop(), P = 60 - (40 > M ? M : 40), ia = b.commandFuns.getRandom(f.tiles[0].x - P - 85, f.tiles[0].x - P - 75), f.tiles.unshift(new Z(-30 < ia + P ? -(P + 30) : ia, b.commandFuns.getRandom(P, 60), b.commandFuns.getRandom(30, 70))), ea(a.x, a.y, a.life), v(c.renStateType.throwing));
     break;
    case c.renStateType.reactivating:
     0 < a.frameIndexs.length ? k = l.frames[a.frameIndexs.shift()] : v(c.renStateType.throwing)
    }
      },
      aa, oa = function() {
    b.canvas.drawImage("bg", 0, 0, b.getImage("bg").width, b.getImage("bg").height, 0, 0, b.canvas.screen.getWidth(), b.canvas.screen.getHeight())
      },
      ba = [],
      x, $, M, pa, T = 5,
      H = 0,
      ca = 1,
      U = 2,
      O = 3,
      da = 4,
      g = 0,
      w = "",
      y = 0,
      w = "CHS",
      g = null == w ? T : H,
      y = b.localStorage.getItem("highScore");
  null == y && (y = 0);
  var ta = function() {
   z = x = 0;
   $ = c.stateType.ready;
   M = 1;
   ea(190, 410 - 2 * a.height, 3);
   v(c.renStateType.standing);
   f.tiles = [new Z(-110, 60, 100), new Z(10, 100, 160), new Z(190, 40, 220)];
   ja = c.lineStateType.holding;
   G = N = 0;
   h.animateFrames = [];
   h.effectFrames = [];
   ha();
   ba = [{
    y: -1
   }, {
    y: 0
   }, {
    y: 1
   }, {
    y: 0
   }, {
    y: -1
   }, {
    y: 0
   }, {
    y: 1
   }, {
    y: 0
   }, {
    y: -1
   }, {
    y: 0
   }, {
    y: 1
   }, {
    y: 0
   }, {
    y: -1
   }, {
    y: 0
   }, {
    y: 1
   }, {
    y: 0
   }, {
    y: -1
   }, {
    y: 0
   }, {
    y: 1
   }, {
    y: 0
   }, {
    y: -1
   }, {
    y: 0
   }, {
    y: 1
   }, {
    y: 0
   }, {
    y: -1
   }, {
    y: 0
   }, {
    y: 1
   }, {
    y: 0
   }, {
    y: -1
   }, {
    y: 0
   }, {
    y: 1
   }, {
    y: 0
   }];
   l.g = 8;
   l.gSpeed = 0;
   l.sSpeed = 0;
   l.mapMovingPath = [];
   Y = [];
   pa = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
   B = A = R = Q = 0;
   S = [];
   W = [];
   aa = !1
  },
      qa, C = {
    x: 0,
    y: 0
      };
  b.events.touchStart(function(a) {
   C = {
    x: a.touches[0].clientX,
    y: a.touches[0].clientY
   };
   sa(C)
  }).touchMove(function(a) {
   C = {
    x: a.touches[0].clientX,
    y: a.touches[0].clientY
   };
   ua(C)
  }).touchEnd(function(a) {
   va(C)
  }).mouseMove(function(a) {
   C = {
    x: a.clientX - d.left,
    y: a.clientY - d.top
   };
   ua(C)
  }).mouseDown(function(a) {
   C = {
    x: a.clientX - d.left,
    y: a.clientY - d.top
   };
   sa(C)
  }).mouseUp(function(a) {
   C = {
    x: a.clientX - d.left,
    y: a.clientY - d.top
   };
   va(C)
  });
  var ra = !1;
  b.run(function() {
   window.scrollTo(0, -5);
   if (window.innerHeight < window.innerWidth && jsGame.canvas.screen.getTouch()) d.showClue(), ra = !0;
   else if (ra && (ra = !1), g == T) d.ctx.fillStyle = "#000000", d.ctx.fillRect(0, 0, d.width, d.height), s.draw("chinese", 0, s.isPressed ? 1 : 0, s.w, s.h, s.x, s.y, s.w, s.h), u.draw("english", 0, u.isPressed ? 1 : 0, u.w, u.h, u.x, u.y, u.w, u.h);
   else if (g == H) {
    d.ctx.fillStyle = "#000000";
    d.ctx.fillRect(0, 0, d.width, d.height);
    var e = b.canvas.screen.getWidth() / b.getImage("logo").width;
    b.canvas.drawImage("logo", 0, 0, b.getImage("logo").width, b.getImage("logo").height, 0, 0, b.getImage("logo").width * e, b.getImage("logo").height * e);
    "ENG" == w ? (p.draw("startE", 0, p.isPressed ? 1 : 0, p.w, p.h, p.x, p.y, p.w, p.h), q.draw("moreE", 0, q.isPressed ? 1 : 0, q.w, q.h, q.x, q.y, q.w, q.h)) : (p.draw("start", 0, p.isPressed ? 1 : 0, p.w, p.h, p.x, p.y, p.w, p.h))
   } else if (g == ca) oa(), b.canvas.drawImage("intro", (b.canvas.screen.getWidth() - b.getImage("intro").width) / 2, 180);
   else if (g == O) oa(), "ENG" == w ? (b.canvas.drawNumber(x, "num", 14, 18, 300, 200, !1).drawImage("scoreE", 180, 200), b.canvas.drawNumber(y, "num", 14, 18, 300, 240, !1).drawImage("HscoreE", 120, 240), m.draw("retryE", 0, m.isPressed ? 1 : 0, m.w, m.h, m.x, m.y, m.w, m.h), n.draw("backE", 0, n.isPressed ? 1 : 0, n.w, n.h, n.x, n.y, n.w, n.h)) : (b.canvas.drawNumber(x, "num", 14, 18, 300, 320, !1).drawImage("score", 180, 320), b.canvas.drawNumber(y, "num", 14, 18, 300, 360, !1).drawImage("Hscore", 120, 360));
   else if (g == da)"ENG" == w ? b.canvas.drawImage("isexitE", (b.canvas.screen.getWidth() - b.getImage("isexit").width) / 2, 300) : b.canvas.drawImage("isexit", (b.canvas.screen.getWidth() - b.getImage("isexit").width) / 2, 300);
   else if (g == U) {
    b.canvas.clearScreen();
    oa();
    switch ($) {
    case c.stateType.ready:
     0 < ba.length ? 0 < ba.length && (qa = ba.shift(), "ENG" == w ? b.canvas.drawImage("noticeE", 16, 115 + qa.y + 310) : b.canvas.drawImage("notice", 26, 115 + qa.y + 310)) : ($ = c.stateType.start, v(c.renStateType.throwing));
     za();
     break;
    case c.stateType.start:
     za();
     break;
    case c.stateType.over:
     K(), 0 < pa.length ? pa.pop() : (dp_submitScore(y, x), y < x && (y = x, b.localStorage.setItem("highScore", y)), g = O, b.gameFlow.over())
    }
    for (e = 0; e < f.tiles.length; e++) f.tiles[e].render();
    b.canvas.strokeStyle("#ffffff");
    switch (ja) {
    case c.lineStateType.shooting:
     0 < h.animateFrames.length ? (V = h.animateFrames.shift(), h.fromX = V.fx, h.fromY = V.fy, h.rootX = V.tx, h.rootY = V.ty, 0 == h.animateFrames.length && (h.effectFrames = [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3])) : 0 < h.effectFrames.length && (xa = h.effectFrames.shift(), b.canvas.drawImage("shengzixiaoguo", 32 * xa, 0, 32, 17, h.rootX - 16, h.rootY, 32, 17), 0 == h.effectFrames.length && v(c.renStateType.startSwinging))
    }
    b.canvas.drawLine(h.fromX + 20, h.fromY, h.rootX, h.rootY);
    b.canvas.drawImage("ren", k.sx, k.sy, k.width, k.height, a.x + k.dx, a.y + k.dy, 2 * k.width, 2 * k.height);
    0 < Y.length && b.canvas.drawImage("life_2", 38 * Y.shift(), 0, 38, 35, 420 + 15 * a.life, 15, 38, 35);
    0 < S.length ? (X = S.shift(), "ENG" == w ? b.canvas.drawImage("jiafenE", A, B, 63, 35, Q, R + X.y, 63, 35) : b.canvas.drawImage("jiafen", A, B, 63, 35, Q, R + X.y, 63, 35), 1 < a.continualHit && ("ENG" == w ? b.canvas.drawImage("tishi_1E", 0, 15, 80, 15, Q + 70, R + X.y, 80, 15) : b.canvas.drawImage("tishi_1", 0, 15, 80, 15, Q + 70, R + X.y, 80, 15))) : 0 < z && (x += parseInt(z), z = 0);
    I.draw("cd", 0, 0, I.w, I.h, I.x, I.y, I.w, I.h);
    "ENG" == w ? (b.canvas.drawImage("HscoreE", 260, 2), b.canvas.drawNumber(y, "num", 14, 18, 470, 2, !1), b.canvas.drawImage("scoreE", 264, 32), b.canvas.drawNumber(x, "num", 14, 18, 420, 32, !1).drawImage("tishi_1E", 124, 15, 80, 15, 120, 10, 80, 15).drawNumber(M, "num", 14, 18, 235, 8, !1)) : (b.canvas.drawImage("Hscore", 260, 2), b.canvas.drawNumber(y, "num", 14, 18, 470, 2, !1), b.canvas.drawImage("score", 264, 32), b.canvas.drawNumber(x, "num", 14, 18, 420, 32, !1).drawImage("tishi_1", 124, 15, 80, 15, 120, 10, 80, 15).drawNumber(M, "num", 14, 18, 235, 8, !1));
    for (e = 0; e < a.life; e++) b.canvas.drawImage("life_1", 430 + 15 * e, 30);
    aa && (0 != l.sSpeed && ("ENG" == w ? b.canvas.drawImage("tishi_1E", 85, 0, 34, 15, 5, 8, 34, 15).drawImage("jiantou", 0 < l.sSpeed ? 52 : 78, 0, 26, 26, 40, 2, 26, 26).drawNumber(Math.abs(l.sSpeed), "num", 14, 18, 70, 6, !0) : b.canvas.drawImage("tishi_1", 85, 0, 34, 15, 5, 8, 34, 15).drawImage("jiantou", 0 < l.sSpeed ? 52 : 78, 0, 26, 26, 40, 2, 26, 26).drawNumber(Math.abs(l.sSpeed), "num", 14, 18, 70, 6, !0)), 0 != l.gSpeed && ("ENG" == w ? b.canvas.drawImage("tishi_1E", 86, 15, 31, 15, 6, 35, 31, 15).drawImage("jiantou", 0 < l.gSpeed ? 26 : 0, 0, 26, 26, 40, 30, 26, 26).drawNumber(Math.abs(l.gSpeed), "num", 14, 18, 70, 34, !0) : b.canvas.drawImage("tishi_1", 86, 15, 31, 15, 6, 35, 31, 15).drawImage("jiantou", 0 < l.gSpeed ? 26 : 0, 0, 26, 26, 40, 30, 26, 26).drawNumber(Math.abs(l.gSpeed), "num", 14, 18, 70, 34, !0)));
    0 < W.length && b.canvas.drawImage("zz", 0, 0, b.getImage("zz").width, b.getImage("zz").height, 0, 0, b.canvas.screen.getWidth(), b.canvas.screen.getHeight()).drawImage("mingzhong", 201 * W.shift(), 0, 201, 146, a.x + 5, a.y + k.height + 10, 201, 146, b.graphics.ANCHOR_HV);
    a.state != c.renStateType.landing && a.state != c.renStateType.moving && a.state != c.renStateType.anxiousLeft && a.state != c.renStateType.anxiousRight && b.keyPressed("menu") && (dp_submitScore(y, x), y < x && (y = x, b.localStorage.setItem("highScore", y)), g = O, b.gameFlow.stop())
   }
  })
 })
};