﻿var link, jsGame;

(function() {
    var e = window.eval,
        t = function(e, t, n) {
            var r = n || {};
            if (t) {
                var i = function() {};
                i.prototype = t.prototype, e.prototype = new i, e.prototype.constructor = e, e.prototype.superClass = t.prototype, i = null
            }
            for (var s in r)
                e.prototype[s] = r[s];
            return r = null, e
        };
    window.requestAnimationFrame = function() {
        return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || window.setTimeout
    }(), window.cancelAnimationFrame = function() {
        return window.cancelAnimationFrame || window.webkitCancelAnimationFrame || window.mozCancelAnimationFrame || window.oCancelAnimationFrame || window.msCancelAnimationFrame || window.clearTimeout
    }(), String || (String = {}), String.format || (String.format = function() {
        if (arguments.length == 0)
            return null;
        var e = arguments[0] || "",
            t;
        for (var n = 1, r = arguments.length; n < r; n++)
            t = new RegExp("\\{" + (n - 1) + "\\}", "gm"), e = e.replace(t, arguments[n]);
        return t = null, e
    }), String.getByteLength || (String.getByteLength = function(e) {
        var t, n = 0,
            r = e || "",
            i = r.length;
        for (t = 0; t < i; t++)
            r.charCodeAt(t) >= 0 & r.charCodeAt(t) <= 255 ? n += 1 : n += 2;
        return t = r = i = null, n
    });
    if (!Array || !Array.prototype)
        Array.prototype = {};
    Array.prototype.indexOfAttr = function(e, t) {
        var n = (typeof e).toLowerCase(),
            r = -1;
        for (var i = 0, s = this.length; i < s; i++)
            if (n == "string" && this[i][e] == t || n == "number" && this[i] == e) {
                r = i;
                break
            }
        return n = null, r
    };
    var n = {
            canvas: {
                id: "linkScreen",
                defaultId: "linkScreen",
                defaultFont: "12px Arial",
                defaultWidth: 240,
                defaultHeight: 320,
                defaultColor: "rgb(0, 0, 0)",
                bgColor: "#000",
                cavansDoms: [],
                ctxs: [],
                device: "",
                fps: 1,
                touch: !1,
                zoom: 1
            },
            system: {
                loadRes: null,
                pageLoad: null,
                menu: null,
                run: null,
                runFn: function() {},
                rafRun: null,
                stop: null,
                over: null,
                zone: null,
                active: null,
                lastDate: Date.now(),
                timeout: 30,
                isPause: !1,
                gameFlow: -1,
                loadedImageToGameFlow: -1,
                zoneArgs: null,
                activeArgs: null,
                spendTime: 0,
                loadResTimer: null,
                playTimer: null
            },
            event: {
                key: 0,
                keys: {
                    up: !1,
                    down: !1,
                    left: !1,
                    right: !1,
                    a: !1,
                    b: !1,
                    c: !1,
                    menu: !1,
                    quit: !1
                },
                lastKey: {
                    up: !1,
                    down: !1,
                    left: !1,
                    right: !1,
                    a: !1,
                    b: !1,
                    c: !1,
                    menu: !1,
                    quit: !1
                },
                pressedKey: {
                    up: !1,
                    down: !1,
                    left: !1,
                    right: !1,
                    a: !1,
                    b: !1,
                    c: !1,
                    menu: !1,
                    quit: !1
                },
                keyPressCtrl: {
                    up: !0,
                    down: !0,
                    left: !0,
                    right: !0,
                    a: !0,
                    b: !0,
                    c: !0,
                    menu: !0,
                    quit: !0
                },
                keyDownGo: !1,
                keyUpGo: !1,
                keyPressedGo: !1,
                keyDownCallBack: null,
                keyUpCallBack: null,
                orientationChange: null,
                touchStart: null,
                touchEnd: null,
                touchMove: null,
                touchCancel: null,
                clickCallBack: null,
                mouseDownCallBack: null,
                mouseUpCallBack: null,
                mouseMoveCallBack: null,
                focused: !1,
                pageFocusCallBack: null,
                pageUnFocusCallBack: null,
                swipeCallBack: null,
                pageOffX: 0,
                pageOffY: 0,
                pageStarOffX: 0,
                pageStarOffY: 0,
                swipeDate: null,
                swipeTimeout: 200,
                swipeRange: 50
            },
            image: {
                imgs: {},
                imgObjs: [],
                initImgs: {},
                asyncImgObjs: {},
                imgCount: 0,
                countLoaded: 0,
                version: "",
                inited: !1
            },
            audio: {
                audios: {}
            },
            ajax: {
                xhrObj: null,
                pool: [],
                poolLength: 5,
                date: null,
                isTimeout: !1,
                param: {
                    type: "get",
                    data: null,
                    dataType: "json",
                    url: "",
                    xhr: null,
                    timeout: 5e3,
                    before: function(e) {},
                    success: function(e, t) {},
                    error: function(e, t) {},
                    complete: function(e) {}
                }
            },
            request: {
                gets: []
            },
            buttonLayout: {
                buttons: [],
                Button: t(function(e) {
                    this.id = e.id, this.value = e.value, this.x = e.x, this.y = e.y, this.width = e.width, this.height = e.height, this.bgColor = e.bgColor, this.bgStroke = e.bgStroke, this.stroke = e.stroke, this.font = e.font, this.imageId = e.imageId, this.sx = e.sx, this.sy = e.sy, this.color = e.color, this.hx = e.hx, this.hy = e.hy, this.hColor = e.hColor, this.dex = e.dex, this.dey = e.dey, this.deColor = e.deColor, this.hided = e.hided, this.disabled = e.disabled, this.path = e.path, this.hovered = !1, this.repeated = !1, this.pressed = !1, this.released = !1, this.goned = !1, this.cacheId = "buttonLayoutCache_" + this.id, this.setDelay(e.delay).refresh()
                }, null, {
                    refresh: function() {
                        m.canvas.pass(this.cacheId, this.width * 3, this.height), this.imageId == "" ? (this.bgColor != "" && m.canvas.fillStyle(this.bgColor).fillRect(0, 0, this.width, this.height).fillRect(this.width, 0, this.width, this.height).fillRect(this.width * 2, 0, this.width, this.height), this.bgStroke != "" && m.canvas.strokeStyle(this.bgStroke).strokeRect(1, 1, this.width - 2, this.height - 2).strokeRect(this.width + 1, 1, this.width - 2, this.height - 2).strokeRect(this.width * 2 + 1, 1, this.width - 2, this.height - 2)) : m.canvas.drawImage(this.imageId, this.sx, this.sy, this.width, this.height, 0, 0, this.width, this.height).drawImage(this.imageId, this.hx, this.hy, this.width, this.height, this.width, 0, this.width, this.height).drawImage(this.imageId, this.dex, this.dey, this.width * 2, this.height, this.width * 2, 0, this.width, this.height);
                        if (this.value != "") {
                            var e = m.canvas.font(this.font).measureText(this.value),
                                t = this.width - e.width >> 1,
                                n = (this.height - e.height >> 1) + parseInt(this.font) - 2;
                            this.stroke != "" && m.canvas.fillStyle(this.stroke).fillText(this.value, t - 1, n).fillText(this.value, t, n - 1).fillText(this.value, t + 1, n).fillText(this.value, t, n + 1).fillText(this.value, t + this.width - 1, n).fillText(this.value, t + this.width, n - 1).fillText(this.value, t + this.width + 1, n).fillText(this.value, t + this.width, n + 1).fillText(this.value, t + this.width * 2 - 1, n).fillText(this.value, t + this.width * 2, n - 1).fillText(this.value, t + this.width * 2 + 1, n).fillText(this.value, t + this.width * 2, n + 1), m.canvas.fillStyle(this.color).fillText(this.value, t, n).fillStyle(this.hColor).fillText(this.value, t + this.width, n).fillStyle(this.deColor).fillText(this.value, t + this.width * 2, n), e = t = n = null
                        }
                        return m.canvas.pass(), this
                    },
                    show: function() {
                        return this.hided = !1, this
                    },
                    hide: function() {
                        return this.hided = !0, this
                    },
                    disable: function(e) {
                        return this.disabled = e, this
                    },
                    setPath: function(e, t) {
                        return this.setDelay(t).path = e || [], this
                    },
                    endPath: function() {
                        return this.path.length == 0
                    },
                    gone: function(e, t) {
                        return this.setPath(e, t).goned = !0, this
                    },
                    setDelay: function(e) {
                        return this.delay = e || 0, this.delayDate = null, this.delay > 0 && (this.delayDate = Date.now()), this
                    },
                    action: function() {
                        if (this.hided)
                            return this;
                        this.delayDate && Date.now() - this.delayDate >= this.delay && (this.delayDate = null);
                        if (!this.delayDate && this.path.length > 0) {
                            var e = this.path.shift();
                            this.x += e[0], this.y += e[1], e = null
                        }
                        return this
                    },
                    render: function() {
                        return this.hided ? this : (m.canvas.drawCache(this.cacheId, this.hovered ? this.width : this.disabled ? this.width * 2 : 0, 0, this.width, this.height, this.x, this.y, this.width, this.height), this)
                    },
                    disposed: function() {
                        return this
                    }
                })
            }
        },
        r = {
            canvas: {
                context: {
                    base: 0
                },
                graphics: {
                    HCENTER: 1,
                    VCENTER: 2,
                    LEFT: 4,
                    RIGHT: 8,
                    TOP: 16,
                    BOTTOM: 32,
                    ANCHOR_LT: 20,
                    ANCHOR_LV: 6,
                    ANCHOR_LB: 36,
                    ANCHOR_HT: 17,
                    ANCHOR_HV: 3,
                    ANCHOR_HB: 33,
                    ANCHOR_RT: 24,
                    ANCHOR_RV: 10,
                    ANCHOR_RB: 40
                },
                trans: {
                    TRANS_MIRROR: 2,
                    TRANS_NONE: 0,
                    TRANS_ROT90: 5,
                    TRANS_ROT180: 3,
                    TRANS_ROT270: 6,
                    TRANS_MIRROR_ROT90: 7,
                    TRANS_MIRROR_ROT180: 1,
                    TRANS_MIRROR_ROT270: 4
                }
            },
            event: {
                key: {
                    up: 38,
                    down: 40,
                    left: 37,
                    right: 39,
                    a: 90,
                    b: 88,
                    c: 67,
                    menu: 49,
                    quit: 50
                }
            },
            system: {
                gameFlowType: {
                    menu: 0,
                    run: 1,
                    stop: 2,
                    over: 3,
                    zone: 4,
                    active: 5,
                    loadImage: 6,
                    loadedImage: 7
                }
            }
        },
        i = {
            getCanvasDom: function() {
                var e;
                return function() {
                    return e || (e = m.getDom(n.canvas.defaultId)), e
                }
            }(),
            getOffsetX: function(e) {
                return e.offsetX || (e.changedTouches && e.changedTouches[0] ? e.changedTouches[0].clientX - i.getCanvasDom().offsetLeft : e.clientX - i.getCanvasDom().offsetLeft) || 0
            },
            getOffsetY: function(e) {
                return e.offsetY || (e.changedTouches && e.changedTouches[0] ? e.changedTouches[0].clientY - i.getCanvasDom().offsetTop : e.clientY - i.getCanvasDom().offsetTop) || 0
            },
            keydown: function(e) {
                var t = i.checkKey(e.keyCode);
                n.event.keyDownGo && n.event.keys[t] != undefined && (n.event.keys[t] = !0), n.event.keyUpGo && n.event.lastKey[t] != undefined && (n.event.lastKey[t] = !1), n.event.keyPressCtrl[t] && n.event.keyPressedGo && (n.event.pressedKey[t] != undefined && (n.event.pressedKey[t] = !0), n.event.keyPressCtrl[t] = !1), n.event.keyDownCallBack != null && n.event.keyDownCallBack(e), t = null
            },
            keyup: function(e) {
                var t = i.checkKey(e.keyCode);
                n.event.keyDownGo && n.event.keys[t] != undefined && (n.event.keys[t] = !1), n.event.keyUpGo && n.event.lastKey[t] != undefined && (n.event.lastKey[t] = !0), n.event.keyPressedGo && (n.event.pressedKey[t] != undefined && (n.event.pressedKey[t] = !1), n.event.keyPressCtrl[t] = !0), n.event.keyUpCallBack != null && n.event.keyUpCallBack(e), t = null
            },
            orientationchange: function(e) {
                n.event.orientationChange != null && n.event.orientationChange(e)
            },
            swipeStart: function(e, t) {
                n.event.swipeCallBack != null && (n.event.swipeDate = Date.now(), n.event.pageStarOffX = e, n.event.pageStarOffY = t)
            },
            swipeSuccess: function(e, t) {
                if (n.event.swipeDate) {
                    if (Date.now() - n.event.swipeDate < n.event.swipeTimeout)
                        if (Math.abs(e - n.event.pageStarOffX) >= n.event.swipeRange || Math.abs(t - n.event.pageStarOffY) >= n.event.swipeRange)
                            return n.event.swipeCallBack(n.event.pageStarOffX, n.event.pageStarOffY, e, t), !0;
                    n.event.swipeDate = null
                }
                return !1
            },
            touchstart: function(e) {
                e.preventDefault(), n.event.pageOffX = i.getOffsetX(e), n.event.pageOffY = i.getOffsetY(e), n.event.touchStart != null && n.event.touchStart(e, n.event.pageOffX, n.event.pageOffY);
                if (i.buttonLayoutEventHandler(e.type, n.event.pageOffX, n.event.pageOffY))
                    return !1;
                i.swipeStart(n.event.pageOffX, n.event.pageOffY)
            },
            touchend: function(e) {
                e.preventDefault();
                if (i.swipeSuccess(n.event.pageOffX, n.event.pageOffY))
                    return !1;
                if (i.buttonLayoutEventHandler(e.type, n.event.pageOffX, n.event.pageOffY))
                    return !1;
                n.event.touchEnd != null && n.event.touchEnd(e, n.event.pageOffX, n.event.pageOffY)
            },
            touchmove: function(e) {
                e.preventDefault(), n.event.pageOffX = i.getOffsetX(e), n.event.pageOffY = i.getOffsetY(e), n.event.touchMove != null && n.event.touchMove(e, n.event.pageOffX, n.event.pageOffY)
            },
            touchcancel: function(e) {
                n.event.pageOffX = i.getOffsetX(e), n.event.pageOffY = i.getOffsetY(e), n.event.touchCancel != null && n.event.touchCancel(e, n.event.pageOffX, n.event.pageOffY)
            },
            click: function(e) {
                n.event.clickCallBack != null && n.event.clickCallBack(e, i.getOffsetX(e), i.getOffsetY(e))
            },
            mouseDown: function(e) {
                var t = i.getOffsetX(e),
                    r = i.getOffsetY(e);
                if (i.buttonLayoutEventHandler(e.type, t, r))
                    return !1;
                n.event.mouseDownCallBack != null && n.event.mouseDownCallBack(e, t, r), i.swipeStart(t, r), t = r = null
            },
            mouseUp: function(e) {
                var t = i.getOffsetX(e),
                    r = i.getOffsetY(e);
                if (i.buttonLayoutEventHandler(e.type, t, r))
                    return !1;
                if (i.swipeSuccess(t, r))
                    return !1;
                n.event.mouseUpCallBack != null && n.event.mouseUpCallBack(e, t, r), t = r = null
            },
            mouseMove: function(e) {
                n.event.mouseMoveCallBack != null && n.event.mouseMoveCallBack(e, i.getOffsetX(e), i.getOffsetY(e))
            },
            pageFocus: function(e) {
                if (n.event.focused)
                    return n.event.focused = !1, !1;
                n.event.pageFocusCallBack != null && n.event.pageFocusCallBack(e)
            },
            pageUnFocus: function(e) {
                n.event.pageUnFocusCallBack != null && n.event.pageUnFocusCallBack(e)
            },
            checkKey: function(e) {
                var t = "0";
                for (var n in r.event.key)
                    if (r.event.key[n] == e) {
                        t = n;
                        break
                    }
                return t
            },
            getDeviceConfig: function() {
                var e = navigator.userAgent.toLowerCase();
                return e.indexOf("duopaosafari") != -1 ? {
                    device: "duopaoSafari",
                    fps: 1,
                    touch: !0,
                    zoom: 1
                } : e.indexOf("iphone") != -1 || e.indexOf("ipod") != -1 ? {
                    device: "iphone",
                    fps: 1,
                    touch: !0,
                    zoom: 1
                } : e.indexOf("ipad") != -1 ? {
                    device: "ipad",
                    fps: 1,
                    touch: !0,
                    zoom: 1
                } : e.indexOf("duopaoandroid") != -1 ? {
                    device: "duopaoAndroid",
                    fps: 1,
                    touch: !0,
                    zoom: 1
                } : e.indexOf("duopaowindowsphone") != -1 ? {
                    device: "duopaoWindowsPhone",
                    fps: 1,
                    touch: !0,
                    zoom: 1
                } : e.indexOf("opera mobi") != -1 ? {
                    device: "operamobile",
                    fps: 1,
                    touch: !0,
                    zoom: 1
                } : e.indexOf("flyflow") != -1 ? {
                    device: "flyflow",
                    fps: 1,
                    touch: !0,
                    zoom: 1
                } : e.indexOf("android") != -1 ? {
                    device: "android",
                    fps: 1,
                    touch: !0,
                    zoom: 1
                } : e.indexOf("iemobile") != -1 ? {
                    device: "iemobile",
                    fps: 1,
                    touch: !1,
                    zoom: 1
                } : e.indexOf("j2me") != -1 ? {
                    device: "j2me",
                    fps: 1,
                    touch: !1,
                    zoom: 1
                } : e.indexOf("symbian v5") != -1 ? {
                    device: "symbian5",
                    fps: 1,
                    touch: !0,
                    zoom: 1
                } : e.indexOf("symbian v3") != -1 ? {
                    device: "symbian3",
                    fps: 1,
                    touch: !1,
                    zoom: 1
                } : e.indexOf("chrome") != -1 ? {
                    device: "chrome",
                    fps: 1,
                    touch: !1,
                    zoom: 1
                } : e.indexOf("firefox") != -1 ? {
                    device: "firefox",
                    fps: 1,
                    touch: !1,
                    zoom: 1
                } : e.indexOf("msie") != -1 ? {
                    device: "ie",
                    fps: .5,
                    touch: !1,
                    zoom: 1
                } : e.indexOf("windows") != -1 ? {
                    device: "ie",
                    fps: .5,
                    touch: !1,
                    zoom: 1
                } : e.indexOf("safari") != -1 ? {
                    device: "safari",
                    fps: 1,
                    touch: !1,
                    zoom: 1
                } : e.indexOf("opera") != -1 ? {
                    device: "opera",
                    fps: 1,
                    touch: !1,
                    zoom: 1
                } : {
                    device: "",
                    fps: 1,
                    touch: !1,
                    zoom: 1
                }
            },
            setImage: function(e, t, r, i, s) {
                if (!e || !t)
                    return !1;
                n.image.imgs[e] || (n.image.imgs[e] = new Image, n.image.imgs[e].onload = function() {
                    n.image.countLoaded++, this.loaded = !0, this.cache && m.canvas.pass(this.id, this.width, this.height).drawImage(this.id, 0, 0).pass().base().delImage(this.id, !0)
                }, n.image.imgs[e].src = t + (n.image.version != "" ? "?v=" + n.image.version : ""), n.image.imgs[e].id = e, n.image.imgs[e].url = t, n.image.imgs[e].benchId = r, n.image.imgs[e].bench = i, n.image.imgs[e].cache = s, n.image.imgs[e].refreshed = !1)
            },
            setAudio: function(e, t, r, i, s, o) {
                if (!e || !t)
                    return !1;
                if (!n.audio.audios[e]) {
                    var u = new Audio(t + (n.image.version != "" ? "?v=" + n.image.version : ""));
                    u.id = e, u.autoplay = i, u.preload = s, u.autobuffer = o, u.loop = r, n.audio.audios[u.id] = u, u = null
                }
            },
            loadingCallBack: function(e, t, r) {
                var i = m.canvas.screen.getWidth(),
                    s = m.canvas.screen.getHeight(),
                    o = i,
                    u = 5,
                    a = parseInt(i - o >> 1),
                    f = s - u,
                    e = e > t ? t : e,
                    l = parseInt(e / t * 100) + "%";
                m.canvas.fillStyle(n.canvas.bgColor).fillRect(0, 0, i, s).fillStyle("#00FFFF").fillRect(a, f, parseInt(e / t * o), u).fillStyle("#FFF").fillText("loading " + r, 5, s - 10).fillText(l, i - m.canvas.measureText(l).width - 5, s - 10), i = s = o = u = a = f = l = null
            },
            loadingEndCallBack: null,
            getAnchor: function(e, t, n, i, s) {
                var o = e,
                    u = t;
                switch (s) {
                    case r.canvas.graphics.ANCHOR_HV:
                        o -= parseInt(n / 2), u -= parseInt(i / 2);
                        break;
                    case r.canvas.graphics.ANCHOR_LV:
                        u -= parseInt(i / 2);
                        break;
                    case r.canvas.graphics.ANCHOR_RV:
                        o -= n, u -= parseInt(i / 2);
                        break;
                    case r.canvas.graphics.ANCHOR_HT:
                        o -= parseInt(n / 2);
                        break;
                    case 0:
                    case r.canvas.graphics.ANCHOR_LT:
                    default:
                        break;
                    case r.canvas.graphics.ANCHOR_RT:
                        o -= n;
                        break;
                    case r.canvas.graphics.ANCHOR_HB:
                        o -= parseInt(n / 2), u -= i;
                        break;
                    case r.canvas.graphics.ANCHOR_LB:
                        u -= i;
                        break;
                    case r.canvas.graphics.ANCHOR_RB:
                        o -= n, u -= i
                }
                return {
                    x: o,
                    y: u
                }
            },
            initUrlParams: function(e) {
                if (e.indexOf("?") >= 0) {
                    var t = e.split("?"),
                        r = [];
                    t[1].indexOf("&") >= 0 ? r = t[1].split("&") : r.push(t[1]);
                    var i = [];
                    for (var s = 0; s < r.length; s++)
                        r[s].indexOf("=") >= 0 && (i = r[s].split("="), n.request.gets[i[0]] = i[1]);
                    i = null, r = null, t = null
                }
            },
            audioEnded: function() {
                m.audio.replay(this.id)
            },
            pageLoaded: function() {
                n.image.inited = !0, n.system.pageLoad(m)
            },
            buttonLayoutAction: function() {
                var e = n.buttonLayout.buttons,
                    t;
                for (var r = e.length - 1; r >= 0; r--)
                    if (t = e[r])
                        t.action().render(), t.goned && t.endPath() && e.splice(r, 1);
                e = t = null
            },
            buttonLayoutEventHandler: function(e, t, r) {
                var i = n.buttonLayout.buttons,
                    s, o = !1;
                for (var u = i.length - 1; u >= 0; u--)
                    if (s = i[u])
                        if (m.comm.collision(s.x, s.y, s.width, s.height, t - 5, r - 5, 10, 10)) {
                            switch (e) {
                                case "mousedown":
                                case "touchstart":
                                    s.hovered = !0, s.repeated = !0, s.pressed = !0, s.released = !1;
                                    break;
                                case "mouseup":
                                case "touchend":
                                    s.hovered && (s.released = !0, s.hovered = !1), s.repeated = !1, s.pressed = !1;
                                    break;
                                default:
                            }
                            o = !0
                        } else if (e == "mouseup" || e == "touchend")
                    s.hovered = !1, s.repeated = !1;
                return i = s = null, o
            }
        },
        s, o, u, a, f, l, c, h, p, d, v = {
            arr: [],
            len: 0,
            v: 0
        };
    link = {
        init: function(e, t) {
            return !e && !t ? (this.version = 1,
                this.request.init(),
                this.canvas.initDevice(),
                this.localStorage.init(),
                this.sessionStorage.init()) : (n.canvas.defaultWidth = e, n.canvas.defaultHeight = t), this
        },
        extend: t,
        setAjax: function(e) {
            return n.ajax.param = this.objExtend(n.ajax.param, e || {}), this
        },
        ajax: function(e) {
            e && n.ajax.pool.length < n.ajax.poolLength && n.ajax.pool.push(e),
            e && e.clear && (n.ajax.pool = []),
            n.ajax.xhr || (n.ajax.xhr = new XMLHttpRequest,
                n.ajax.xhr.onreadystatechange = function() {
                    if (n.ajax.isTimeout)
                        return !1;
                    var e = n.ajax.xhr,
                        t = n.ajax.xhrObj;
                    if (t && e.readyState == 4) {
                        n.ajax.date && (clearTimeout(n.ajax.date), n.ajax.date = null);
                        if (e.status == 200) {
                            var r;
                            switch (t.dataType) {
                                case "HTML":
                                case "SCRIPT":
                                case "XML":
                                    r = e.responseText;
                                    break;
                                case "TEXT":
                                default:
                                    r = e.responseText.replace(/<[^>].*?>/g, "");
                                    break;
                                case "JSON":
                                    r = m.getJson(e.responseText)
                            }
                            t.success(r, t), t.complete(t)
                        } else
                            t.error(t, "error");
                        n.ajax.xhrObj = null, m.ajax()
                    }
                    e = t = null
                });
            if (n.ajax.xhrObj == null && n.ajax.pool.length > 0) {
                n.ajax.xhrObj = this.objExtend(n.ajax.param, n.ajax.pool.shift() || {});
                var t = n.ajax.xhr,
                    r = n.ajax.xhrObj,
                    i = n.ajax.xhrObj.url,
                    s = null,
                    o = r.data;
                r.type = r.type.toUpperCase(), r.dataType = r.dataType.toUpperCase(), n.ajax.isTimeout = !1;
                if (typeof o == "string")
                    s = o;
                else if (typeof o == "object") {
                    s = [];
                    for (var u in o)
                        s.push(u + "=" + o[u]);
                    s = s.join("&")
                }
                r.type == "GET" && (i += "?" + s), t.open(r.type, i, !0), r.before(n.ajax.xhrObj), r.type == "POST" && t.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"), t.send(s), t = r = s = o = i = null, n.ajax.date = setTimeout(function() {
                    m.ajax({
                        clear: !0
                    }), n.ajax.isTimeout = !0, n.ajax.xhrObj && (n.ajax.xhrObj.error(n.ajax.xhrObj, "timeout"), n.ajax.xhrObj = null)
                }, n.ajax.xhrObj.timeout)
            }
            return this
        },
        getDom: function(e) {
            try {
                return document.getElementById(e)
            } catch (t) {
                return document.all[e]
            }
        },
        objExtend: function() {
            var e = this.clone(arguments[0]) || {},
                t = 1,
                n = arguments.length,
                r = !1,
                i;
            typeof e == "boolean" && (r = e, e = arguments[1] || {}, t = 2), typeof e != "object" && (e = {}), n == t && (e = this, --t);
            if (!arguments[1])
                return e;
            for (; t < n; t++)
                if ((i = arguments[t]) != null)
                    for (var s in i) {
                        var o = e[s],
                            u = i[s];
                        if (e === u)
                            continue;
                        r && u && typeof u == "object" && !u.nodeType ? e[s] = this.objExtend(r, o || (u.length != null ? [] : {}), u) : u !== undefined && (e[s] = u)
                    }
            return e
        },
        getJson: function(t) {
            var n = {};
            try {
                window.JSON ? n = JSON.parse(t) : n = e("(" + t + ")")
            } catch (r) {}
            return n
        },
        clone: function() {
            var e = arguments[0],
                t = e || [];
            if (typeof t == "object")
                if (t.length != undefined) {
                    e = [];
                    for (var n = 0, r = t.length; n < r; n++) {
                        if (t[n] === undefined)
                            continue;
                        t[n] != null && typeof t[n] == "object" ? t[n].length != undefined ? e[n] = t[n].slice(0) : e[n] = t[n] : e[n] = t[n]
                    }
                } else {
                    e = {};
                    for (var n in t) {
                        if (t[n] === undefined)
                            continue;
                        t[n] != null && typeof t[n] == "object" ? t[n].length != undefined ? e[n] = t[n].slice(0) : e[n] = t[n] : e[n] = t[n]
                    }
                }
            return t = null, e
        },
        classes: {},
        comm: {
            registerNotify: function(e, t) {
                e != null && e.register(t)
            },
            rangeRegisterNotify: function(e, t) {
                for (var n = 0; n < t.length; n++)
                    m.commandFuns.registerNotify(e, t[n])
            },
            unRegisterNotify: function(e, t) {
                e != null && e.unregister(t)
            },
            rangeUnRegisterNotify: function(e, t) {
                for (var n = 0; n < t.length; n++)
                    m.commandFuns.unRegisterNotify(e, t[n])
            },
            getRandom: function(e, t) {
                if (!t) {
                    var n = e;
                    if (!n || n < 0)
                        n = 0;
                    return Math.round(Math.random() * n)
                }
                return Math.round(Math.random() * (t - e) + e)
            },
            getArray: function(e, t) {
                v.arr = [], v.len = e.toString().length, v.v = e;
                for (var n = 0; n < v.len; n++)
                    v.arr.push(v.v % 10), v.v = parseInt(v.v / 10);
                return t || v.arr.reverse(), v.arr
            },
            inArray: function(e, t) {
                var n, r = t.length;
                for (n = 0; n < r; n++)
                    if (e == t[n])
                        return n;
                return -1
            },
            collision: function(e, t, n, r, i, s, o, u) {
                return o && Math.abs(e + (n >> 1) - (i + (o >> 1))) < n + o >> 1 && Math.abs(t + (r >> 1) - (s + (u >> 1))) < r + u >> 1 ? !0 : !1
            },
            circleCollision: function(e, t, n, r, i, s) {
                var o = Math.abs(e - r),
                    u = Math.abs(t - i);
                return Math.sqrt(o * o + u * u) < n + s ? !0 : !1
            },
            rect2CircleCollision: function(e, t, n, r, i, s, o) {
                var u = !1;
                return (u = this.circleCollision(e, t, 1, i, s, o)) || (u = this.circleCollision(e + n, t, 1, i, s, o)) || (u = this.circleCollision(e + n, t + r, 1, i, s, o)) || (u = this.circleCollision(e, t + r, 1, i, s, o)) || (u = this.collision(e, t, n, r, i - (o >> 1), s - (o >> 1), o, o)), u
            },
            polygonCollision: function(e, t, n, r, i, s, o, u) {
                return this.polygonSAT(e, t, n, r, i, s, o, u) && this.polygonSAT(t, e, i, s, n, r, u, o)
            },
            polygonSAT: function(e, t, n, r, i, s, o, u) {
                var a = e.length,
                    f = t.length,
                    l = n || 0,
                    c = r || 0,
                    h = i || 0,
                    p = s || 0,
                    d = o,
                    v = u,
                    m = l + e[e.length - 1][0],
                    g = c + e[e.length - 1][1],
                    y, b, w, E, S, x, T, N, C, k, L;
                for (k = 0; k < a; k++) {
                    y = l + e[k][0], b = c + e[k][1], w = b - g, E = m - y, S = w * m + E * g, x = !0;
                    for (L = 0; L < f; L++) {
                        T = h + t[L][0], N = p + t[L][1], C = w * T + E * N - S;
                        if (C < 0) {
                            x = !1;
                            break
                        }
                    }
                    if (x) {
                        if (d[0] != 0 || d[1] != 0 || v[0] != 0 || v[1] != 0) {
                            S = w * (m + d[0]) + E * (g + d[1]);
                            for (L = 0; L < f; L++) {
                                T = h + t[L][0] + v[0], N = p + t[L][1] + v[1], C = w * T + E * N - S;
                                if (C < 0) {
                                    x = !1;
                                    break
                                }
                            }
                        }
                        if (x)
                            return !1
                    }
                    m = y, g = b
                }
                return !0
            },
            setMatrixRotate: function(e, t) {
                if (!e || !e[0])
                    return null;
                var n = 50,
                    r = 50,
                    i, s, o = Math.PI / 180 * t,
                    u = Math.sin(o),
                    a = Math.cos(o);
                for (var f = 0; f < e.length; f++)
                    i = e[f][0], s = e[f][1], e[f][0] = a * i - u * s, e[f][1] = u * i + a * s;
                return this
            },
            createPath: function(e, t, n, r, i) {
                var s = [],
                    o = e || 0,
                    u = t || 0,
                    a = n || 0,
                    f = r || 0,
                    l = a - o,
                    c = f - u,
                    h = Math.sqrt(Math.pow(l, 2) + Math.pow(c, 2)),
                    p = i || 5,
                    d = p,
                    v = 0,
                    m = 0,
                    g, y, b = Math.atan2(c, l) / Math.PI * 180;
                b = b >= 0 ? b : b + 360, d >= h && (d = h >> 1);
                while (d < h + p)
                    d = d > h ? h : d, g = d * Math.cos(b / 180 * Math.PI), y = d * Math.sin(b / 180 * Math.PI), s.unshift([g - v, y - m]), v = g, m = y, d += p;
                return s.angle = b + 90, o = u = a = f = l = c = h = p = d = b = null, s
            }
        },
        localStorage: function() {
            var e, t, n = function() {
                var e;
                try {
                    e = window.localStorage, e.getItem || (e.getItem = function() {
                        return null
                    }),
                    e.setItem || (e.setItem = function() {})
                } catch (t) {
                    e = {
                        getItem: function() {
                            return null
                        },
                        setItem: function() {}
                    }
                }
                return e
            };
            return {
                init: function() {
                    return e = this, t || (t = n()), e
                },
                setItem: function(n, r) {
                    try {
                        t.setItem(n, r)
                    } catch (i) {}
                    return e
                },
                getItem: function(e) {
                    return t.getItem(e)
                },
                removeItem: function(n) {
                    return t.removeItem(n), e
                },
                clear: function() {
                    return t.clear(), e
                },
                key: function(e) {
                    return t.key(e)
                },
                getLength: function() {
                    return t.length
                },
                base: function() {
                    return m
                }
            }
        }(),
        sessionStorage: function() {
            var e,
                t,
                n = function() {
                    var e;
                    try {
                        //e={},
                        //e.getItem=function(){return null},
                        //e.setItem=function(){}

                        e = window.sessionStorage,
                        e.getItem || (e.getItem = function() {
                            return null
                        }),
                        e.setItem || (e.setItem = function() {})
                    } catch (t) {
                        e = {
                            getItem: function() {
                                return null
                            },
                            setItem: function() {}
                        }
                    }
                    return e
                };
            return {
                init: function() {
                    return e = this, t || (t = n()), e
                },
                setItem: function(n, r) {
                    return t.setItem(n, r), e
                },
                getItem: function(e) {
                    return t.getItem(e)
                },
                removeItem: function(n) {
                    return t.removeItem(n), e
                },
                clear: function() {
                    return t.clear(), e
                },
                key: function(e) {
                    return t.key(e)
                },
                getLength: function() {
                    return t.length
                },
                base: function() {
                    return m
                }
            }
        }(),
        pageLoad: function(e) {
            return n.system.pageLoad == null && (n.system.pageLoad = e, window.addEventListener("load", function() {
                m.main(n.system.pageLoad)
            }, !1)), m
        },
        main: function(e) {
            n.system.pageLoad == null && (n.system.pageLoad = e), this.canvas.init(), this.graphics.ANCHOR_LT = r.canvas.graphics.ANCHOR_LT, this.graphics.ANCHOR_LV = r.canvas.graphics.ANCHOR_LV, this.graphics.ANCHOR_LB = r.canvas.graphics.ANCHOR_LB, this.graphics.ANCHOR_HT = r.canvas.graphics.ANCHOR_HT, this.graphics.ANCHOR_HV = r.canvas.graphics.ANCHOR_HV, this.graphics.ANCHOR_HB = r.canvas.graphics.ANCHOR_HB, this.graphics.ANCHOR_RT = r.canvas.graphics.ANCHOR_RT, this.graphics.ANCHOR_RV = r.canvas.graphics.ANCHOR_RV, this.graphics.ANCHOR_RB = r.canvas.graphics.ANCHOR_RB;
            var t = this.getDom(n.canvas.defaultId);
            t && (this.canvas.screen.getTouch() ? (window.addEventListener("orientationchange", i.orientationchange, !1), t.addEventListener("touchstart", i.touchstart, !1), t.addEventListener("touchend", i.touchend, !1), t.addEventListener("touchmove", i.touchmove, !1), t.addEventListener("touchcancel", i.touchcancel, !1)) : (document.onkeydown = i.keydown, document.onkeyup = i.keyup, t.addEventListener("click", i.click, !1), t.addEventListener("mousedown", i.mouseDown, !1), t.addEventListener("mouseup", i.mouseUp, !1), t.addEventListener("mousemove", i.mouseMove, !1))), t = null;
            var s = this.canvas.screen.getDevice();
            return s == "ipad" || s == "iphone" ? (n.event.focused = !0, window.addEventListener("pageshow", i.pageFocus, !1), window.addEventListener("pagehide", i.pageUnFocus, !1)) : (s == "firefox" && (n.event.focused = !0), window.addEventListener("focus", i.pageFocus, !1), window.addEventListener("blur", i.pageUnFocus, !1)), this.canvas.fillStyle(n.canvas.bgColor).fillRect(0, 0, this.canvas.screen.getWidth(), this.canvas.screen.getHeight()), n.image.inited = !1, this.gameFlow.run().base().play(), n.image.imgObjs.length > 0 ? this.loadImage(n.image.imgObjs) : i.pageLoaded(), this
        },
        menu: function(e) {
            return typeof e == "function" && (n.system.menu = e), this
        },
        run: function(e) {
            return typeof e == "function" && (n.system.runFn = e), this
        },
        stop: function(e) {
            return typeof e == "function" && (n.system.stop = e), this
        },
        over: function(e) {
            return typeof e == "function" && (n.system.over = e), this
        },
        zone: function(e) {
            return typeof e == "function" && (n.system.zone = e), this
        },
        active: function(e) {
            return typeof e == "function" && (n.system.active = e), this
        },
        play: function() {
            return n.system.run || (n.system.run = function() {
                var e = Date.now();
                switch (n.system.gameFlow) {
                    case r.system.gameFlowType.menu:
                        n.system.menu();
                        break;
                    case r.system.gameFlowType.run:
                        n.system.runFn();
                        break;
                    case r.system.gameFlowType.stop:
                        n.system.stop();
                        break;
                    case r.system.gameFlowType.over:
                        n.system.over();
                        break;
                    case r.system.gameFlowType.zone:
                        n.system.zone(n.system.zoneArgs);
                        break;
                    case r.system.gameFlowType.active:
                        n.system.active(n.system.activeArgs);
                        break;
                    case r.system.gameFlowType.loadImage:
                        if (i.loadingCallBack != null) {
                            var t = n.image.imgCount,
                                s = n.image.countLoaded > t ? t : n.image.countLoaded;
                            s == t && (n.system.gameFlow = r.system.gameFlowType.loadedImage), t > 0 && i.loadingCallBack(s, t, "image"), s == t && i.loadingEndCallBack && (i.loadingEndCallBack(s, t, "image"), i.loadingEndCallBack = null), s = t = null
                        }
                        break;
                    case r.system.gameFlowType.loadedImage:
                        n.system.gameFlow = n.system.loadedImageToGameFlow, n.image.imgObjs = [], n.image.countLoaded = 0, n.image.inited || i.pageLoaded();
                        break;
                    default:
                }
                i.buttonLayoutAction(), n.system.spendTime = Date.now() - e, e = null
            }), n.system.playTimer || (n.system.isPause = !1, (n.system.rafRun = function() {
                var e = Date.now();
                e - n.system.lastDate >= n.system.timeout - n.system.spendTime && (n.system.lastDate = e, n.system.isPause || n.system.run()), e = null, n.system.rafRun && (n.system.playTimer = requestAnimationFrame(n.system.rafRun))
            })()), this
        },
        pause: function() {
            return n.system.playTimer && (n.system.isPause = !0, n.system.rafRun = null, cancelAnimationFrame(n.system.playTimer), n.system.playTimer = null), this
        },
        gameFlow: {
            menu: function() {
                return n.system.menu != null && (n.system.gameFlow = r.system.gameFlowType.menu, m.resetKeys()), this
            },
            run: function() {
                return n.system.runFn != null && (n.system.gameFlow = r.system.gameFlowType.run, m.resetKeys()), this
            },
            stop: function() {
                return n.system.stop != null && (n.system.gameFlow = r.system.gameFlowType.stop, m.resetKeys()), this
            },
            over: function() {
                return n.system.over != null && (n.system.gameFlow = r.system.gameFlowType.over, m.resetKeys()), this
            },
            zone: function(e) {
                return n.system.zone != null && (n.system.gameFlow = r.system.gameFlowType.zone, n.system.zoneArgs = e, m.resetKeys()), this
            },
            active: function(e) {
                return n.system.active != null && (n.system.gameFlow = r.system.gameFlowType.active, n.system.activeArgs = e, m.resetKeys()), this
            },
            isIn: function(e) {
                return n.system.gameFlow == r.system.gameFlowType[e]
            },
            base: function() {
                return m
            }
        },
        keyRepeated: function(e) {
            return n.event.keyDownGo || (n.event.keyDownGo = !0), n.event.keys[e]
        },
        keyPressed: function(e) {
            n.event.keyPressedGo || (n.event.keyPressedGo = !0);
            var t = n.event.pressedKey[e];
            return n.event.pressedKey[e] = !1, t
        },
        keyReleased: function(e) {
            n.event.keyUpGo || (n.event.keyUpGo = !0);
            var t = n.event.lastKey[e];
            return n.event.lastKey[e] = !1, t
        },
        setKeyCode: function(e, t) {
            return n.event.keys[e] = !1, n.event.lastKey[e] = !1, n.event.pressedKey[e] = !1, n.event.keyPressCtrl[e] = !0, r.event.key[e] = t, this
        },
        resetKeys: function() {
            for (var e in n.event.keys)
                n.event.keys[e] = !1;
            for (var e in n.event.lastKey)
                n.event.lastKey[e] = !1;
            for (var e in n.event.pressedKey)
                n.event.pressedKey[e] = !1;
            for (var e in n.event.keyPressCtrl)
                n.event.keyPressCtrl[e] = !0;
            return this
        },
        canvas: {
            init: function() {
                return o = {
                    x: 0,
                    y: 0
                }, u = {
                    fillColor: "#000000",
                    strokeColor: "#000000"
                }, a = {
                    x: 0,
                    y: 0
                }, f = {
                    x: 0,
                    y: 0
                }, l = {
                    x: 0,
                    y: 0,
                    fillStyle: "#FFFFFF",
                    strokeStyle: "#CCCCCC"
                }, this.pass()
            },
            initDevice: function() {
                return h = i.getDeviceConfig(), n.canvas.device = h.device, n.canvas.fps = h.fps, n.canvas.touch = h.touch, n.canvas.zoom = h.zoom, this
            },
            pass: function(e, t, r) {
                var i, o;
                return !e || e == "" ? i = n.canvas.defaultId : i = e, n.canvas.ctxs[i] || (o = this.base().getDom(i) || document.createElement("canvas"), n.canvas.ctxs[i] = null, delete n.canvas.ctxs[i], n.canvas.ctxs[i] = o.getContext("2d"), o.width = t ? t : n.canvas.defaultWidth, o.style.width = parseInt(o.width * n.canvas.zoom) + "px", o.height = r ? r : n.canvas.defaultHeight, o.style.height = parseInt(o.height * n.canvas.zoom) + "px", n.canvas.cavansDoms[i] = null, delete n.canvas.cavansDoms[i], n.canvas.cavansDoms[i] = o), s = n.canvas.ctxs[i], s.font = n.canvas.defaultFont, c = n.canvas.cavansDoms[i], p = parseInt(c.width), d = parseInt(c.height), this.screen.setId(i), this
            },
            font: function(e) {
                return n.canvas.defaultFont = e, s.font = n.canvas.defaultFont, this
            },
            del: function(e) {
                return n.canvas.ctxs[e] && (n.canvas.ctxs[e] = null, delete n.canvas.ctxs[e], n.canvas.cavansDoms[e] = null, delete n.canvas.cavansDoms[e]), this
            },
            setCurrent: function(e) {
                return _canvas.pass(e)
            },
            screen: {
                setId: function(e) {
                    return n.canvas.ctxs[e] && (n.canvas.id = e), this
                },
                getId: function() {
                    return n.canvas.id
                },
                getWidth: function() {
                    return p
                },
                setWidth: function(e) {
                    return n.canvas.defaultWidth = e, c && (c.width = n.canvas.defaultWidth, c.style.width = c.width + "px", p = parseInt(c.width)), this
                },
                getHeight: function() {
                    return d
                },
                setHeight: function(e) {
                    return n.canvas.defaultHeight = e, c && (c.height = n.canvas.defaultHeight, c.style.height = c.height + "px", d = parseInt(c.height)), this
                },
                getDevice: function() {
                    return n.canvas.device
                },
                getFps: function() {
                    return n.canvas.fps
                },
                setFps: function(e) {
                    return e > 0 && (n.canvas.fps = e), this
                },
                getTouch: function() {
                    return n.canvas.touch
                },
                getZoom: function() {
                    return n.canvas.zoom
                }
            },
            fillStyle: function(e) {
                return s.fillStyle = e, this
            },
            fillRect: function(e, t, n, r, o) {
                return n = n ? n : 0, r = r ? r : 0, o ? f = i.getAnchor(e, t, n, r, o) : (f.x = e, f.y = t), s.fillRect(f.x, f.y, n, r), this
            },
            fillText: function(e, t, r, i) {
                return s.font = i || n.canvas.defaultFont, s.fillText(e, t, r), this
            },
            clearRect: function(e, t, n, r) {
                return s.clearRect(e, t, n, r), this
            },
            clearScreen: function() {
                return this.clearRect(0, 0, p, d)
            },
            fillScreen: function() {
                return this.fillRect(0, 0, p, d)
            },
            strokeStyle: function(e) {
                return s.strokeStyle = e, this
            },
            lineWidth: function(e) {
                return s.lineWidth = e || 1, this
            },
            strokeRect: function(e, t, n, r, o) {
                return o ? a = i.getAnchor(e, t, n, r, o) : (a.x = e, a.y = t), s.strokeRect(a.x, a.y, n, r), this
            },
            strokeText: function(e, t, r, i) {
                return s.font = i || n.canvas.defaultFont, s.strokeText(e, t, r), this
            },
            setColor: function(e, t, n) {
                return n == null ? (u.fillColor = e, u.strokeColor = t ? t : e) : (u.fillColor = "rgb(" + e + ", " + t + ", " + n + ")", u.strokeColor = u.fillColor), this.fillStyle(u.fillColor).strokeStyle(u.strokeColor)
            },
            drawImage: function(e, t, r, u, a, f, l, c, h, p) {
                var d = m.getImage(e);
                if (d.refreshed)
                    this.drawCache(e, t, r, u, a, f, l, c, h, p);
                else if (d.src != null)
                    c != null && (t = t < 0 ? 0 : t, c = c <= 0 ? .1 : c), h != null && (r = r < 0 ? 0 : r, h = h <= 0 ? .1 : h), u != null && c != null && (u = u <= 0 ? .1 : t + u <= d.width ? u : d.width - t), a != null && h != null && (a = a <= 0 ? .1 : r + a <= d.height ? a : d.height - r), d.loaded && (u ? a ? p ? (o = i.getAnchor(f, l, c, h, p), s.drawImage(d, t, r, u, a, o.x, o.y, c, h)) : s.drawImage(d, t, r, u, a, f, l, c, h) : (o = i.getAnchor(t, r, d.width, d.height, u), s.drawImage(d, o.x, o.y)) : s.drawImage(d, t, r));
                else {
                    var v = n.image.asyncImgObjs[e];
                    v && !v.inited && (i.setImage(v.id, v.src, v.benchId, v.bench, v.cache), v.inited = !0), v = null
                }
                return d = null, this
            },
            drawRotate: function(e, t, r, i, o, u, a, f, l, c) {
                var h = parseInt(f >> 1),
                    p = parseInt(l >> 1),
                    d = m.getImage(e),
                    v = d.src ? d : n.canvas.cavansDoms[e];
                return u -= h, a -= p, s.save(), s.translate(u + h, a + p), s.rotate(c * Math.PI / 180), s.translate(-(u + h), -(a + p)), s.drawImage(v, t, r, i, o, u, a, f, l), s.restore(), v = null, d = null, p = null, h = null, this
            },
            drawCache: function(e, t, r, u, a, f, l, c, h, p) {
                var d = n.canvas.cavansDoms[e];
                return d && (c != null && (t = t < 0 ? 0 : t, c = c <= 0 ? .1 : c), h != null && (r = r < 0 ? 0 : r, h = h <= 0 ? .1 : h), u != null && c != null && (u = u <= 0 ? .1 : t + u <= d.width ? u : d.width - t), a != null && h != null && (a = a <= 0 ? .1 : r + a <= d.height ? a : d.height - r), u ? a ? p ? (o = i.getAnchor(f, l, c, h, p), s.drawImage(d, t, r, u, a, o.x, o.y, c, h)) : s.drawImage(d, t, r, u, a, f, l, c, h) : (o = i.getAnchor(t, r, d.width, d.height, u), s.drawImage(d, o.x, o.y)) : s.drawImage(d, t, r)), d = null, this
            },
            drawRegion: function(e, t, n, i, o, u, a, f, l) {
                switch (u) {
                    case r.canvas.trans.TRANS_NONE:
                    default:
                        s.transform(1, 0, 0, 1, a, f);
                        break;
                    case r.canvas.trans.TRANS_ROT90:
                        s.transform(0, 1, -1, 0, o + a, f);
                        break;
                    case r.canvas.trans.TRANS_ROT180:
                        s.transform(-1, 0, 0, -1, i + a, o + f);
                        break;
                    case r.canvas.trans.TRANS_ROT270:
                        s.transform(0, -1, 1, 0, a, i + f);
                        break;
                    case r.canvas.trans.TRANS_MIRROR:
                        s.transform(-1, 0, 0, 1, i + a, f);
                        break;
                    case r.canvas.trans.TRANS_MIRROR_ROT90:
                        s.transform(0, -1, -1, 0, o + a, i + f);
                        break;
                    case r.canvas.trans.TRANS_MIRROR_ROT180:
                        s.transform(1, 0, 0, -1, a, o + f);
                        break;
                    case r.canvas.trans.TRANS_MIRROR_ROT270:
                        s.transform(0, 1, 1, 0, a, f)
                }
                var c = m.getImage(e),
                    h = c.cache ? this.drawCache : this.drawImage;
                return h(e, t, n, i, o, 0, 0, i, o), s.setTransform(1, 0, 0, 1, 0, 0), h = null, c = null, this
            },
            drawRegionAndZoom: function(e, t, n, i, o, u, a, f, l, c, h) {
                switch (u) {
                    case r.canvas.trans.TRANS_NONE:
                    default:
                        s.transform(1, 0, 0, 1, a, f);
                        break;
                    case r.canvas.trans.TRANS_ROT90:
                        s.transform(0, 1, -1, 0, h + a, f);
                        break;
                    case r.canvas.trans.TRANS_ROT180:
                        s.transform(-1, 0, 0, -1, c + a, h + f);
                        break;
                    case r.canvas.trans.TRANS_ROT270:
                        s.transform(0, -1, 1, 0, a, c + f);
                        break;
                    case r.canvas.trans.TRANS_MIRROR:
                        s.transform(-1, 0, 0, 1, c + a, f);
                        break;
                    case r.canvas.trans.TRANS_MIRROR_ROT90:
                        s.transform(0, -1, -1, 0, h + a, c + f);
                        break;
                    case r.canvas.trans.TRANS_MIRROR_ROT180:
                        s.transform(1, 0, 0, -1, a, h + f);
                        break;
                    case r.canvas.trans.TRANS_MIRROR_ROT270:
                        s.transform(0, 1, 1, 0, a, f)
                }
                var p = m.getImage(e),
                    d = p.cache ? this.drawCache : this.drawImage;
                return d(e, t, n, i, o, 0, 0, c, h), s.setTransform(1, 0, 0, 1, 0, 0), d = null, p = null, this
            },
            drawNumber: function(e, t, n, r, i, s, o, u, a) {
                var f = e.toString(),
                    l = f.length,
                    c = u ? u : n,
                    h = a ? a : r;
                if (o == "center") {
                    var d = i + parseInt(p - c * l >> 1);
                    for (var v = 0; v < l; v++)
                        this.drawImage(t, parseInt(f.charAt(v)) * n, 0, n, r, d + v * c, s, c, h);
                    d = null
                } else if (o == 1)
                    for (var v = 0; v < l; v++)
                        this.drawImage(t, parseInt(f.charAt(v)) * n, 0, n, r, i + v * c, s, c, h);
                else if (o == 0)
                    for (var v = l - 1; v >= 0; v--)
                        this.drawImage(t, parseInt(f.charAt(v)) * n, 0, n, r, i - (l - 1 - v) * c, s, c, h, m.graphics.ANCHOR_RT);
                return h = null, c = null, l = null, f = null, this
            },
            moveTo: function(e, t) {
                return s.moveTo(e, t), this
            },
            lineTo: function(e, t) {
                return s.lineTo(e, t), this
            },
            stroke: function() {
                return s.stroke(), this
            },
            fill: function() {
                return s.fill(), this
            },
            beginPath: function() {
                return s.beginPath(), this
            },
            closePath: function() {
                return s.closePath(), this
            },
            arc: function(e, t, n, r, i, o) {
                return s.arc(e, t, n, r, i, o), this
            },
            quadraticCurveTo: function(e, t, n, r) {
                return s.quadraticCurveTo(e, t, n, r), this
            },
            bezierCurveTo: function(e, t, n, r, i, o) {
                return s.bezierCurveTo(e, t, n, r, i, o), this
            },
            measureText: function(e) {
                var t = s.measureText(e),
                    n = t.width,
                    r = t.height ? t.height : parseInt(s.font);
                return {
                    width: this.screen.getDevice() == "j2me" ? s.measureText(e) : n,
                    height: r
                }
            },
            translate: function(e, t) {
                return s.translate(e, t), this
            },
            drawLine: function(e, t, n, r) {
                return this.beginPath().moveTo(e, t).lineTo(n, r).closePath().stroke()
            },
            drawRect: function(e, t, n, r, i) {
                return this.strokeRect(e, t, n, r, i)
            },
            drawString: function(e, t, i, o, u, a, f, c) {
                l.x = t, l.y = i, s.font = c || n.canvas.defaultFont;
                if (o)
                    switch (o) {
                        case r.canvas.graphics.LEFT:
                            l.x = 0;
                            break;
                        case r.canvas.graphics.VCENTER:
                            l.x = parseInt(this.screen.getWidth() - this.measureText(e).width >> 1);
                            break;
                        case r.canvas.graphics.RIGHT:
                            l.x = this.screen.getWidth() - this.measureText(e).width;
                            break;
                        default:
                    }
                return u && (a ? l.fillStyle = a : l.fillStyle = "#000000", f ? l.strokeStyle = f : l.strokeStyle = "#CCCCCC", this.fillStyle(l.strokeStyle).fillText(e, l.x + 1, l.y + 1, c).fillStyle(l.fillStyle)), this.fillText(e, l.x, l.y, c).fillStyle(n.canvas.defaultColor)
            },
            drawSubstring: function(e, t, n, r, i, s, o, u, a, f) {
                return this.drawString(e.substring(t, t + n), r, i, s, o, u, a, f)
            },
            clip: function() {
                return s.clip(), this
            },
            save: function() {
                return s.save(), this
            },
            restore: function() {
                return s.restore(), this
            },
            rect: function(e, t, n, r) {
                return s.rect(e, t, n, r), this
            },
            rotate: function(e) {
                return s.rotate(e), this
            },
            setTransform: function(e, t, n, r, i, o) {
                return s.setTransform(e, t, n, r, i, o), this
            },
            scale: function(e, t) {
                return s.scale(e, t), this
            },
            globalAlpha: function(e) {
                return s.globalAlpha = e, this
            },
            getContext: function() {
                return s
            },
            base: function() {
                return m
            }
        },
        pushImage: function(e, t) {
            if (n.image.inited)
                return this;
            var r;
            for (var i = 0, s = e.length; i < s; i++)
                r = e[i], r && !n.image.initImgs[r.id] && (n.image.initImgs[r.id] = !0, n.image.imgObjs.push(e[i]));
            return this.loadingEndCallBack(t), r = null, this
        },
        loadImage: function(e, t) {
            if (n.system.gameFlow != r.system.gameFlowType.loadImage && e.length > 0) {
                n.system.loadedImageToGameFlow = n.system.gameFlow, n.system.gameFlow = r.system.gameFlowType.loadImage, n.image.imgObjs = e, n.image.imgCount = n.image.imgObjs.length, n.image.countLoaded = 0;
                for (var s = 0, o; o = n.image.imgObjs[s]; s++)
                    n.image.imgs[o.id] ? n.image.countLoaded++ : i.setImage(o.id, o.src, o.benchId);
                this.loadingEndCallBack(t)
            }
            return this
        },
        asyncImage: function(e) {
            var t;
            for (var r = 0, i = e.length; r < i; r++)
                t = e[r] || {}, n.image.asyncImgObjs[t.id] || (n.image.asyncImgObjs[t.id] = t);
            return t = null, this
        },
        verImage: function(e) {
            return n.image.version == "" && (n.image.version = e), this
        },
        loadingCallBack: function(e) {
            return typeof e == "function" && (i.loadingCallBack = e), this
        },
        loadingEndCallBack: function(e) {
            return typeof e == "function" && (i.loadingEndCallBack = e), this
        },
        addImage: function(e, t) {
            return e && t && !n.image.imgs[e] && (n.image.imgs[e] = t), this
        },
        getImage: function(e) {
            return n.image.imgs[e] ? n.image.imgs[e] : {
                src: null
            }
        },
        delImage: function(e, t) {
            return n.image.imgs[e] && (n.image.imgs[e] = null, delete n.image.imgs[e], t && (n.image.imgs[e] = {
                id: e,
                loaded: !0,
                cache: !0,
                refreshed: !0
            })), this
        },
        getAsyncImage: function(e) {
            return n.image.asyncImgObjs[e] ? n.image.asyncImgObjs[e] : {
                src: null
            }
        },
        clearAsyncImageCache: function() {
            try {
                var e = n.image.imgs,
                    t, r;
                for (var i in e)
                    t = e[i], t && (r = n.image.asyncImgObjs[i], r && (r.inited = !1, this.delImage(i).canvas.del(i)));
                e = t = r = null
            } catch (s) {}
            return this
        },
        audio: {
            play: function(e) {
                var t = n.audio.audios[e];
                if (t)
                    try {
                        t.currentTime >= t.duration ? this.replay(e) : t.paused && t.play()
                    } catch (r) {}
                return t = null, this
            },
            playRange: function(e, t, r) {
                var i = n.audio.audios[e];
                if (i)
                    try {
                        i.__timeupdateCallBack__ || i.addEventListener("timeupdate", i.__timeupdateCallBack__ = function() {
                            this.currentTime >= this.__to__ && (this.loop ? this.currentTime = this.__from__ : this.pause())
                        }, !1), i.__from__ = t == null ? 0 : t, i.__to__ = r == null ? i.duration : r, this.setCurrentTime(i.id, i.__from__).play(i.id)
                    } catch (s) {}
                return i = null, this
            },
            pause: function(e) {
                if (n.audio.audios[e])
                    try {
                        n.audio.audios[e].pause()
                    } catch (t) {}
                return this
            },
            pauseAll: function() {
                for (var e in n.audio.audios)
                    this.pause(e);
                return this
            },
            mute: function(e, t) {
                if (n.audio.audios[e])
                    try {
                        n.audio.audios[e].muted = t
                    } catch (r) {}
            },
            vol: function(e, t) {
                if (n.audio.audios[e])
                    try {
                        n.audio.audios[e].volume = t
                    } catch (r) {}
                return this
            },
            loop: function(e, t) {
                if (n.audio.audios[e])
                    try {
                        n.audio.audios[e].loop = t
                    } catch (r) {}
                return this
            },
            replay: function(e) {
                return this.setCurrentTime(e, 0).play(e), this
            },
            setCurrentTime: function(e, t) {
                var r = n.audio.audios[e];
                if (r)
                    try {
                        t < 0 ? t = 0 : t > r.duration && (t = r.duration), r.currentTime = t || 0
                    } catch (i) {}
                return r = null, this
            },
            getAudio: function(e) {
                return n.audio.audios[e]
            },
            del: function(e) {
                var t = n.audio.audios[e];
                return t && t.__timeupdateCallBack__ && (t.pause(), t.removeEventListener("timeupdate", t.__timeupdateCallBack__, !1), n.audio.audios[e] = null, delete n.audio.audios[e]), t = null, this
            },
            base: function() {
                return m
            }
        },
        initAudio: function(e) {
            if (!window.Audio)
                return this;
            if (e.length > 0) {
                n.audio.audios = {};
                var t, r, s, o, u;
                for (var a = 0; a < e.length; a++)
                    t = e[a], t && i.setAudio(t.id, t.src, t.loop, t.autoplay, t.preload, t.autobuffer);
                t = r = s = o = u = null
            }
            return this
        },
        setRunFrequency: function(e) {
            return n.system.timeout = e, this
        },
        events: {
            keyDown: function(e) {
                return n.event.keyDownGo || (n.event.keyDownGo = !0), n.event.keyUpGo || (n.event.keyUpGo = !0), n.event.keyPressedGo || (n.event.keyPressedGo = !0), n.event.keyDownCallBack = e, this
            },
            keyUp: function(e) {
                return n.event.keyDownGo || (n.event.keyDownGo = !0), n.event.keyUpGo || (n.event.keyUpGo = !0), n.event.keyPressedGo || (n.event.keyPressedGo = !0), n.event.keyUpCallBack = e, this
            },
            orientationChange: function(e) {
                return n.event.orientationChange = e, this
            },
            touchStart: function(e) {
                return n.event.touchStart = e, this
            },
            touchEnd: function(e) {
                return n.event.touchEnd = e, this
            },
            touchMove: function(e) {
                return n.event.touchMove = e, this
            },
            touchCancel: function(e) {
                return n.event.touchCancel = e, this
            },
            click: function(e) {
                return n.event.clickCallBack = e, this
            },
            mouseDown: function(e) {
                return n.event.mouseDownCallBack = e, this
            },
            mouseUp: function(e) {
                return n.event.mouseUpCallBack = e, this
            },
            mouseMove: function(e) {
                return n.event.mouseMoveCallBack = e, this
            },
            createEvent: function(e, t) {
                var n = document.getElementById(e);
                if (n) {
                    var r = document.createEvent("HTMLEvents");
                    r.initEvent(t, !1, !0), n.dispatchEvent(r), r = null
                }
                n = null
            },
            pageFocus: function(e) {
                return n.event.pageFocusCallBack = e, this
            },
            pageUnFocus: function(e) {
                return n.event.pageUnFocusCallBack = e, this
            },
            swipe: function(e, t, r) {
                n.event.swipeCallBack = e, t != null && (n.event.swipeTimeout = t), r != null && (n.event.swipeRange = r)
            },
            base: function() {
                return m
            }
        },
        ui: {},
        graphics: {
            HCENTER: r.canvas.graphics.HCENTER,
            VCENTER: r.canvas.graphics.VCENTER,
            LEFT: r.canvas.graphics.LEFT,
            RIGHT: r.canvas.graphics.RIGHT,
            TOP: r.canvas.graphics.TOP,
            BOTTOM: r.canvas.graphics.BOTTOM
        },
        trans: {
            TRANS_NONE: r.canvas.trans.TRANS_NONE,
            TRANS_ROT90: r.canvas.trans.TRANS_ROT90,
            TRANS_ROT180: r.canvas.trans.TRANS_ROT180,
            TRANS_ROT270: r.canvas.trans.TRANS_ROT270,
            TRANS_MIRROR: r.canvas.trans.TRANS_MIRROR,
            TRANS_MIRROR_ROT90: r.canvas.trans.TRANS_MIRROR_ROT90,
            TRANS_MIRROR_ROT180: r.canvas.trans.TRANS_MIRROR_ROT180,
            TRANS_MIRROR_ROT270: r.canvas.trans.TRANS_MIRROR_ROT270
        },
        request: {
            init: function() {
                i.initUrlParams(location.href)
            },
            get: function(e) {
                return n.request.gets[e] ? n.request.gets[e] : ""
            }
        },
        buttonLayout: {
            create: function(e) {
                var t = this.base().objExtend({
                    id: "",
                    value: "",
                    x: 0,
                    y: 0,
                    width: 60,
                    height: 30,
                    bgColor: "#000",
                    bgStroke: "#FFF",
                    stroke: "rgba(0,0,0,0)",
                    font: "12px Arial",
                    imageId: "",
                    sx: 0,
                    sy: 0,
                    color: "#FFF",
                    hx: 0,
                    hy: 0,
                    hColor: "#0FF",
                    dex: 0,
                    dey: 0,
                    deColor: "#CCC",
                    hided: !1,
                    disabled: !1,
                    path: []
                }, e || {});
                return this.get(t.id) || n.buttonLayout.buttons.push(new n.buttonLayout.Button(t)), t = null, this
            },
            destroy: function(e) {
                var t = n.buttonLayout.buttons,
                    r;
                for (var i = t.length - 1; i >= 0; i--)
                    if (r = t[i])
                        if (r.id == e) {
                            r.disposed(), t.splice(i, 1);
                            break
                        }
                return t = r = null, this
            },
            clear: function() {
                var e = n.buttonLayout.buttons,
                    t;
                for (var r = e.length - 1; r >= 0; r--)
                    if (t = e[r])
                        t.disposed(), e.splice(r, 1);
                return e = t = null, this
            },
            gone: function(e, t, n) {
                var r = this.get(e);
                if (r) {
                    var i = t || [];
                    r.gone(i, n), i = null
                }
                return r = null, this
            },
            get: function(e) {
                var t = n.buttonLayout.buttons;
                return t[t.indexOfAttr("id", e)]
            },
            show: function(e) {
                var t = this.get(e);
                return t && t.show(), t = null, this
            },
            hide: function(e) {
                var t = this.get(e);
                return t && t.hide(), t = null, this
            },
            disable: function(e, t) {
                var n = this.get(e);
                return n && n.disable(t), n = null, this
            },
            repeated: function(e) {
                var t = this.get(e);
                if (t)
                    return t.repeated
            },
            pressed: function(e) {
                var t = this.get(e);
                if (t) {
                    var n = t.pressed;
                    return t.pressed = !1, n
                }
            },
            released: function(e) {
                var t = this.get(e);
                if (t) {
                    var n = t.released;
                    return t.released = !1, n
                }
            },
            base: function() {
                return m
            }
        }
    }.init();
    var m = jsGame = link,
        g = document.getElementsByTagName("head")[0],
        y = null,
        b = null,
        w = null,
        E = null,
        S = function() {
            b && (clearTimeout(b), b = null)
        };
    link.getScript = function(e) {
        if (!g || y)
            return !1;
        var t = m.objExtend({
            url: "",
            before: function() {},
            success: function() {},
            error: function(e) {},
            timeout: 5e3,
            contentType: "text/javascript",
            destroyed: !0
        }, e || {});
        return t.url != "" && (t.before(), y = document.createElement("script"), y.type = t.contentType, y.async = !0, y.src = t.url, y.destroyed = t.destroyed, w = t.success, E = t.error, y.onload = function() {
            S(), w && (w(), w = null), this.destroyed && g.removeChild(this), y = null
        }, g.appendChild(y), S(), b = setTimeout(function() {
            S(), E && (E("timeout"), E = null), y && y.destroyed && g.removeChild(y), y = null
        }, t.timeout)), t = null, m
    };
    var x = function() {
        return ((1 + Math.random()) * 65536 | 0).toString(16).substring(1)
    };
    link.getNewGuid = function() {
        return x() + x() + "-" + x() + "-" + x() + "-" + x() + "-" + x() + x() + x()
    }, link.classes.Observer = function() {
        this.group = []
    }, link.classes.Observer.prototype.register = function(e) {
        if (e == null)
            return this;
        var t = m.comm.inArray(e, this.group);
        return t == -1 && this.group.push(e), this
    }, link.classes.Observer.prototype.unregister = function(e) {
        if (e == null)
            return this;
        var t = m.commandFuns.inArray(e, this.group);
        return t > -1 && this.group.splice(t, 1), this
    }, link.classes.Observer.prototype.notify = function(e) {
        for (var t = 0; t < this.group.length; t++)
            this.group[t] != null && this.group[t](e);
        return this
    }, link.classes.Observer.prototype.clear = function() {
        return this.group.length > 0 && this.group.splice(0, this.group.length), this
    }, link.classes.Timer = function(e, t, n, r, i) {
        this.id = e, this._initTime = t, this._dateTime = Date.now(), this.time = this._initTime, this.callBack = n, this.millisec = r || 1e3, this.data = i, this.timeout = null
    }, link.classes.Timer.prototype.stop = function() {
        this.timeout && (clearTimeout(this.timeout), this.timeout = null)
    }, link.classes.Timer.prototype.start = function(e) {
        e && (this.time = this._initTime, this._dateTime = Date.now()), this.stop(), this.timeout = setTimeout(function(e) {
            var t = Date.now(),
                n = parseInt(Math.round((t - e._dateTime) / e.millisec));
            e._dateTime = t, e.time -= n, e.callBack ? e.callBack(e) : e.stop(), e.time >= 0 ? e.start() : (e.stop(), e.time = 0), t = n = null
        }, this.millisec, this)
    }, link.classes.WebSocket = function(e, t, n, r, i) {
        this.ipPort = e || "", this.socket = new WebSocket(this.ipPort), this.socket.onopen = t, this.socket.onmessage = n, this.socket.onclose = r, this.socket.onerror = i
    }, link.classes.WebSocket.prototype.send = function(e) {
        this.socket.send(e)
    }, link.classes.WebSocket.prototype.close = function() {
        this.socket.close()
    }, link.classes.observer = link.classes.Observer, link.classes.timer = link.classes.Timer, link.classes.webSocket = link.classes.websocket = link.classes.WebSocket, link.commandFuns = link.comm, link.commandFuns.collisionCheck = link.commandFuns.collision, link.commandFuns.circleCollisionCheck = link.commandFuns.circleCollision, link.initImage = link.pushImage, typeof define == "function" && define("lib/link", [], function() {
        return link
    })
})(), define("lib/action", ["lib/link"], function(e) {
    var t = function(e, t) {
            return e == 0 && t == 0 ? 0 : e > 0 && t < 0 ? 1 : e > 0 && t == 0 ? 2 : e > 0 && t > 0 ? 3 : e == 0 && t > 0 ? 4 : e < 0 && t > 0 ? 5 : e < 0 && t == 0 ? 6 : e < 0 && t < 0 ? 7 : 0
        },
        n = function(t, n, r, i, s) {
            var o = [];
            if (s.length > 0) {
                var i, u;
                for (var a = 0; a < s.length; a++) {
                    i = [], u = s[a].frames;
                    for (var f = 0; f < u.length; f++)
                        i.push({
                            args: [u[f][0], u[f][1], u[f][2]],
                            step: u[f][3]
                        });
                    o.push(new e.action.sprite(i, s[a].loop, 0))
                }
                return i = u = null, o
            }
            return t
        };
    e.action = {}, e.action.Role = function(e, t, r, i, s, o, u, a) {
        this.imageNames = s || [], this.rects = o || [], this.frames = u || [], this.actions = a || [], this.sprites = n(e, this.imageNames, this.rects, this.frames, this.actions) || [], this.x = t || 0, this.y = r || 0, this.dx = 0, this.dy = 0, this.step = 0, this.id = "", this.mapOffx = this.x, this.mapOffy = this.y, this.svx = null, this.svy = null, this.current = i || 0, this._cr = this.current, this.zoom = 1, this.angle = 0, this._zooms = [], this._angles = [], this._moveDs = [4, 7, 5, 5, 6, -5, -5, -7], this._stopDs = [0, -3, 1, 1, 2, -1, -1, -3], this.dsIndex = 4, this._path = [];
        var f = this.getSprite(),
            l = f.getFrame(),
            c = this.frames[l.args[0]];
        this._fA = c.fA, this.aR = c.aR, this.bR = c.bR, this._skipMoveDs = !1, this._stopedAction = null, c = l = f = null, this.onend = null, this.onstart = null, this._locked = !1, this.speed = 5, this.links = [], this.polyAR = [
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0]
        ], this.aabbAR = [
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0]
        ], this.polyBR = [
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0]
        ], this.aabbBR = [
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0]
        ]
    }, e.action.Role.prototype.setSprite = function(t, n, r) {
        if (this._locked)
            return this;
        var i = t != undefined ? t : 0,
            s = i >= 0 ? e.trans.TRANS_NONE : e.trans.TRANS_MIRROR,
            o, u;
        this._cr != i && (this._cr = i, i < 0 && (i = Math.abs(i)), this.current = i >= this.sprites.length ? this.sprites.length - 1 : i, this.sprites.length > 1 && this.setTrans(s), o = this.getSprite(), u = o.getFrame(), n || o.setFrame(0), r && (this._stopedAction = this._cr), this.updateFrameParam());
        for (var a = 0, f; f = this.links[a]; a++)
            f.setSprite(t, n, r);
        return i = trans = o = u = null, this
    }, e.action.Role.prototype.addLinks = function(t) {
        this.links = t || [];
        for (var n = 0, r; r = this.links[n]; n++)
            r.setSprite(this.getSprite().trans == e.trans.TRANS_NONE ? this.current : -this.current).setStep(this.step);
        return this
    }, e.action.Role.prototype.clearLinks = function() {
        return this.links = [], this
    }, e.action.Role.prototype.lockSprite = function() {
        return this._locked = !0, this
    }, e.action.Role.prototype.unlockSprite = function() {
        return this._locked = !1, this
    }, e.action.Role.prototype.setTrans = function(e) {
        return this.getSprite().trans = e, this
    }, e.action.Role.prototype.getSprite = function(e) {
        return this.sprites[e == null ? this.current : e]
    }, e.action.Role.prototype.getFrame = function(e) {
        return this.frames[e == null ? this.getSprite().getFrame().args[0] : e]
    }, e.action.Role.prototype.updateFrameParam = function(t) {
        var n = this.getSprite();
        if (!n)
            return n = null, this;
        var r = n.getFrame(),
            i;
        if (r && r.args)
            if (i = this.frames[r.args[0]]) {
                this._fA = i.fA, this.aR = i.aR, this.bR = i.bR;
                var s = this.getAttackRect(),
                    o = this.getBodyRect(),
                    u = 0,
                    a = 0,
                    f = 0,
                    l = 0;
                this.polyAR[0][0] = s.x, this.polyAR[0][1] = s.y, this.polyAR[1][0] = s.x + s.width, this.polyAR[1][1] = s.y, this.polyAR[2][0] = s.x + s.width, this.polyAR[2][1] = s.y + s.height, this.polyAR[3][0] = s.x, this.polyAR[3][1] = s.y + s.height, this.polyBR[0][0] = o.x, this.polyBR[0][1] = o.y, this.polyBR[1][0] = o.x + o.width, this.polyBR[1][1] = o.y, this.polyBR[2][0] = o.x + o.width, this.polyBR[2][1] = o.y + o.height, this.polyBR[3][0] = o.x, this.polyBR[3][1] = o.y + o.height, this.angle != 0 && e.comm.setMatrixRotate(this.polyAR, this.angle).setMatrixRotate(this.polyBR, this.angle);
                var c = 0,
                    h = this.polyAR,
                    p = this.aabbAR;
                while (c++ < 2) {
                    for (var d = 0, v; v = h[d]; d++)
                        v[0] > a && (a = v[0]), v[0] < u && (u = v[0]), v[1] > l && (l = v[1]), v[1] < f && (f = v[1]);
                    p[0][0] = u, p[0][1] = f, p[1][0] = a, p[1][1] = f, p[2][0] = a, p[2][1] = l, p[3][0] = u, p[3][1] = l, h = this.polyBR, p = this.aabbBR
                }
                s = o = u = a = f = l = null
            }
        return n = r = i = null, this
    }, e.action.Role.prototype.action = function() {
        var e = this.getSprite();
        if (!e)
            return this;
        var n = e.getFrame(),
            r = 0,
            i = 0;
        if (n) {
            this.updateFrameParam();
            if (this._path.length > 0) {
                var s = this._path.shift();
                r = s[0] || 0, i = s[1] || 0, s = null, this._skipMoveDs || this.setSprite(this._moveDs[this.dsIndex = t(r, i)], !0), this.svx = r, this.svy = i, this.mapOffx += this.svx, this.mapOffy += this.svy
            } else
                this.svx != null && this.svy != null && (this._skipMoveDs || (this.setSprite(this._stopedAction || this._stopDs[this.dsIndex = t(this.svx, this.svy)]), this._stopedAction = null), this.onend && this.onend(this), this._skipMoveDs = !1, this.svx = null, this.svy = null);
            if (this._zooms.length > 0) {
                var o = this._zooms.shift();
                typeof~~ o == "number" && this.setZoom(o), o = null
            }
            if (this._angles.length > 0) {
                var u = this._angles.shift();
                typeof~~ u == "number" && this.setRotate(u), o = null
            }
            this.x += n.args[1] + r, this.y += n.args[2] + i;
            var a;
            for (var f = 0, l; l = this.links[f]; f++)
                l.x = this.x + (l.dx || 0), l.y = this.y + (l.dy || 0), l.getSprite().setFrame(e.current), l.updateFrameParam();
            a = null
        }
        return e.nextFrame(), e = r = i = n = null, this
    }, e.action.Role.prototype.render = function(t) {
        var n = this.getSprite();
        if (n && this._fA) {
            var r = this._fA,
                i = r.length,
                s = e.canvas,
                o = n.trans,
                u, a, f;
            if (this.angle > 0) {
                var l = r[0],
                    c = this.x,
                    h = this.y;
                e.canvas.save().translate(c, h).rotate(this.angle * Math.PI / 180).translate(-c, -h), l = c = h = null
            }
            for (var p = 0; p < i; p++)
                u = this.rects[r[p][0]][r[p][1]], a = this.imageNames[r[p][0]], f = e.getImage(a), o == e.trans.TRANS_NONE ? s.drawImage(a, u[0], u[1], u[2], u[3], this.zoom == 1 ? ~~(this.x + this.dx + r[p][2] * this.zoom) : this.x + this.dx + r[p][2] * this.zoom, this.zoom == 1 ? ~~(this.y + this.dy + r[p][3] * this.zoom) : this.y + this.dy + r[p][3] * this.zoom, u[2] * this.zoom, u[3] * this.zoom) : this.zoom == 1 ? s.drawRegion(a, u[0], u[1], u[2], u[3], o, ~~ (this.x + this.dx - (r[p][2] + u[2])), ~~ (this.y + this.dy + r[p][3])) : s.drawRegionAndZoom(a, u[0], u[1], u[2], u[3], o, this.x + this.dx - (r[p][2] + u[2]) * this.zoom, this.y + this.dy + r[p][3] * this.zoom, null, u[2] * this.zoom, u[3] * this.zoom), !f.loaded && f.bench && s.drawImage(f.bench.id || f.benchId, f.bench.sx || 0, f.bench.sy || 0, f.bench.sw || f.bench.w, f.bench.sh || f.bench.h, ~~ (this.x + this.dx - (f.bench.w * this.zoom >> 1)), ~~ (this.y + this.dy - f.bench.h * this.zoom), f.bench.w * this.zoom, f.bench.h * this.zoom);
            this.angle > 0 && e.canvas.restore();
            for (var d = 0, v; v = this.links[d]; d++)
                v.render();
            s = i = r = o = u = a = f = null
        }
        return n = null, this
    }, e.action.Role.prototype.setZoom = function(e) {
        return this.zoom = e, this
    }, e.action.Role.prototype.setZoomTransition = function(e) {
        return e && e.length > 0 && (this._zooms = e), this
    }, e.action.Role.prototype.endZoomTransition = function() {
        return this._zooms.length == 0
    }, e.action.Role.prototype.getBodyRect = function(t, n) {
        var r = this.getSprite(t != null ? Math.abs(t) : null);
        if (!r)
            return null;
        var i = r.getFrame(n);
        if (!i)
            return null;
        var s = this.frames[i.args[0]].bR;
        return t == null && r.trans != e.trans.TRANS_NONE || t < 0 ? {
            x: -(s[0] + s[2] * this.zoom),
            y: s[1] * this.zoom,
            width: s[2] * this.zoom,
            height: s[3] * this.zoom
        } : {
            x: s[0] * this.zoom,
            y: s[1] * this.zoom,
            width: s[2] * this.zoom,
            height: s[3] * this.zoom
        }
    }, e.action.Role.prototype.getAttackRect = function(t, n) {
        var r = this.getSprite(t != null ? Math.abs(t) : null);
        if (!r)
            return null;
        var i = r.getFrame(n);
        if (!i)
            return null;
        var s = this.frames[i.args[0]].aR;
        return t == null && r.trans != e.trans.TRANS_NONE || t < 0 ? {
            id: this.id,
            x: -(s[0] + s[2] * this.zoom),
            y: s[1] * this.zoom,
            width: s[2] * this.zoom,
            height: s[3] * this.zoom
        } : {
            id: this.id,
            x: s[0] * this.zoom,
            y: s[1] * this.zoom,
            width: s[2] * this.zoom,
            height: s[3] * this.zoom
        }
    }, e.action.Role.prototype.getAABBBodyRect = function() {
        return {
            id: this.id,
            x: this.aabbBR[0][0],
            y: this.aabbBR[0][1],
            width: Math.abs(this.aabbBR[1][0] - this.aabbBR[0][0]),
            height: Math.abs(this.aabbBR[2][1] - this.aabbBR[1][1])
        }
    }, e.action.Role.prototype.getAABBAttackRect = function() {
        return {
            id: this.id,
            x: this.aabbAR[0][0],
            y: this.aabbAR[0][1],
            width: Math.abs(this.aabbAR[1][0] - this.aabbAR[0][0]),
            height: Math.abs(this.aabbAR[2][1] - this.aabbAR[1][1])
        }
    }, e.action.Role.prototype.setStep = function(e) {
        this.step = e || 0;
        for (var t = 0, n = this.sprites.length; t < n; t++)
            this.sprites[t].setStep(e);
        for (var r = 0, i; i = this.links[r]; r++)
            i.setStep(this.step);
        return this
    }, e.action.Role.prototype.collision = function(t, n, r) {
        if (!t)
            return !1;
        var i = n || "aR",
            s = r || "aR",
            o, u;
        return i == "aR" ? o = this.getAttackRect() : i == "bR" && (o = this.getBodyRect()), s == "aR" ? u = t.getAttackRect() : s == "bR" && (u = t.getBodyRect()), o && u ? e.comm.collision(~~(this.x + this.dx + o.x), ~~ (this.y + this.dy + o.y), ~~o.width, ~~o.height, ~~ (t.x + t.dx + u.x), ~~ (t.y + t.dy + u.y), ~~u.width, ~~u.height) : !1
    }, e.action.Role.prototype.collisionInput = function(t, n, r, i, s) {
        var o = s || "aR",
            u;
        return o == "aR" ? u = this.getAttackRect() : o == "bR" && (u = this.getBodyRect()), u ? e.comm.collision(~~(this.x + this.dx + u.x), ~~ (this.y + this.dy + u.y), ~~u.width, ~~u.height, t, n, r, i) : !1
    }, e.action.Role.prototype.circleCollisionInput = function(t, n, r, i) {
        var s = i || "aR",
            o;
        return s == "aR" ? o = this.getAttackRect() : s == "bR" && (o = this.getBodyRect()), o ? e.comm.rect2CircleCollision(~~(this.x + this.dx + o.x), ~~ (this.y + this.dy + o.y), ~~o.width, ~~o.height, t, n, r) : !1
    }, e.action.Role.prototype.polygonSATCollision = function(t, n, r) {
        if (!t)
            return !1;
        var i = n || "aR",
            s = r || "aR",
            o, u;
        return i == "aR" ? o = this.polyAR : i == "bR" && (o = this.polyBR), s == "aR" ? u = t.polyAR : s == "bR" && (u = t.polyBR), o && u ? e.comm.polygonCollision(o, u, this.x + this.dx, this.y + this.dy, t.x + t.dx, t.y + t.dy) : !1
    }, e.action.Role.prototype.setLoop = function(e) {
        for (var t = 0, n = this.sprites.length; t < n; t++)
            this.sprites[t].setLoop(e);
        return this
    }, e.action.Role.prototype.setPath = function(e, t) {
        return this._path = e || [], this._path.length > 0 && this.onstart && this.onstart(this), t && (this._skipMoveDs = !0), this
    }, e.action.Role.prototype.concatPath = function(e) {
        return this._path = this._path.concat(e || []), this
    }, e.action.Role.prototype.endPath = function() {
        return this._path.length == 0
    }, e.action.Role.prototype.clearPath = function() {
        return this._path = [], this
    }, e.action.Role.prototype.getPathCount = function() {
        return this._path.length
    }, e.action.Role.prototype.getFirstPath = function() {
        return this._path.length > 0 ? this._path[0] : [0, 0]
    }, e.action.Role.prototype.moveTo = function(t, n, r) {
        return r && (this.speed = Math.abs(r)), this.setPath(e.comm.createPath(this.mapOffx, this.mapOffy, t, n, this.speed)), this
    }, e.action.Role.prototype.setMoveDs = function(e) {
        return this._moveDs = e || [4, 7, 5, 5, 6, -5, -5, -7], this
    }, e.action.Role.prototype.setStopDs = function(e) {
        return this._stopDs = e || [0, -3, 1, 1, 2, -1, -1, -3], this
    }, e.action.Role.prototype.doMoveDs = function(e) {
        return e != null && e >= 0 && e < 8 && (this.dsIndex = e), this.setSprite(this._moveDs[this.dsIndex]), this
    }, e.action.Role.prototype.doStopDs = function(e) {
        return e != null && e >= 0 && e < 8 && (this.dsIndex = e), this.setSprite(this._stopDs[this.dsIndex]), this
    }, e.action.Role.prototype.mark = function(e, t, n, r) {
        return e != null && (this.x = e), t != null && (this.y = t), n != null && (this.mapOffx = n), r != null && (this.mapOffy = r), this
    }, e.action.Role.prototype.setSpeed = function(e, t) {
        return e && (this.speed = Math.abs(e)), this.nodeXStep = e, this.nodeYStep = t, this
    }, e.action.Role.prototype.setRotate = function(e) {
        return e != this.angle && (Math.abs(e) > 360 && (e %= 360), this.angle = e < 0 ? 360 + e : e), this
    }, e.action.Role.prototype.setRotateTransition = function(e) {
        return e && e.length > 0 && (this._angles = e), this
    }, e.action.Role.prototype.endRotateTransition = function() {
        return this._angles.length == 0
    }, e.action.Role.prototype.move = function(e, t) {
        return e != null && (this.x += e), t != null && (this.y += t), this
    }, e.action.Role.prototype.rotate = function(e) {
        return e != null && this.setRotate(this.angle + e), this
    }, e.action.Role.prototype.stoped = function() {
        return this.svx == null
    }, e.action.Role.prototype.getCurrent = function() {
        return this.current * (this.getSprite().trans == e.trans.TRANS_NONE ? 1 : -1)
    }, e.action.Sprite = function(t, n, r, i) {
        this.frames = t || [], this.loop = n, this.current = r || 0, this.step = i || 0, this.trans = e.trans.TRANS_NONE, this.setFrame(r), this.runStep = this.getFrame().step || this.step
    }, e.action.Sprite.prototype.setFrame = function(e) {
        return this.current = e >= this.frames.length ? this.frames.length - 1 : e > 0 ? e : 0, this.getFrame().step && (this.runStep = this.getFrame().step), this
    }, e.action.Sprite.prototype.getFrame = function(e) {
        return this.frames[e == null ? this.current : e]
    }, e.action.Sprite.prototype.nextFrame = function() {
        return !this.loop && this.endFrame() ? this : (this.frames.length > 0 && (this.runStep <= 0 ? (this.loop ? (this.current++, this.current %= this.frames.length) : this.current < this.frames.length - 1 && this.current++, this.getFrame().step ? this.runStep = this.getFrame().step : this.runStep = this.step) : this.runStep--), this)
    }, e.action.Sprite.prototype.preFrame = function() {
        return this.frames.length > 0 && (this.runStep <= 0 ? (this.loop ? (this.current--, this.current < 0 && (this.current = this.frames.length - 1)) : this.current > 0 && this.current--, this.getFrame().step ? this.runStep = this.getFrame().step : this.runStep = this.step) : this.runStep--), this
    }, e.action.Sprite.prototype.endFrame = function(e) {
        var t = this.frames.length - 1;
        return e != null && e >= 0 && e <= this.frames.length - 1 && (t = e), this.current >= t && this.runStep == 0
    }, e.action.Sprite.prototype.firstFrame = function() {
        return this.current == 0 && this.runStep == 0
    }, e.action.Sprite.prototype.setStep = function(e) {
        return this.step = e || 0, this.runStep = this.getFrame().step || this.step, this
    }, e.action.Sprite.prototype.setLoop = function(e) {
        return this.loop = e, this
    };
    var r, i = function(e) {
        return e.sprites.length > 0 ? e.sprites[0].frames.length > 0 && (e.sprites[0].runStep <= 0 ? (e.sprites[0].runStep = e.sprites[0].step, r = e.sprites[0].frames.shift(), e.sprites[0].frames.length == 0 && e.sprites.shift()) : (r = e.sprites[0].getFrame(), e.sprites[0].runStep--)) : r = null, r
    };
    return e.action.Fragment = function(e) {
        this.sprites = e || []
    }, e.action.Fragment.prototype.queue = function() {
        return i(this)
    }, e.action.role = e.action.Role, e.action.sprite = e.action.Sprite, e.action.fragment = e.action.Fragment, link.action
}), define("host0", ["lib/link"], function(e) {
    e.asyncImage([{
        id: "host0",
        src: "images/man.png"
    }]);
    var t = ["host0"],
        n = [
            [
                [0, 0, 24, 47],
                [24, 0, 20, 46],
                [44, 0, 24, 48]
            ]
        ],
        r = [{
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 0, -14, -47, 0]
            ]
        }, {
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 1, -9, -46, 0]
            ]
        }, {
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 2, -12, -47, 0]
            ]
        }],
        i = [{
            loop: !0,
            frames: [
                [0, 0, 0, 0],
                [1, 0, 0, 0],
                [2, 0, 0, 0],
                [1, 0, 0, 0]
            ]
        }];
    return {
        get: function(s, o) {
            var u = s >= 0 && i[s] ? [i[s]] : i;
            return new e.action.role([], 0, 0, 0, o ? o : t, n, r, u || i)
        }
    }
}), define("host1", ["lib/link"], function(e) {
    e.asyncImage([{
        id: "host1",
        src: "images/woman.png"
    }]);
    var t = ["host1"],
        n = [
            [
                [0, 0, 23, 47],
                [22, 0, 23, 46],
                [45, 0, 23, 48]
            ]
        ],
        r = [{
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 0, -14, -47, 0]
            ]
        }, {
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 1, -14, -47, 0]
            ]
        }, {
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 2, -14, -47, 0]
            ]
        }],
        i = [{
            loop: !0,
            frames: [
                [0, 0, 0, 0],
                [1, 0, 0, 0],
                [2, 0, 0, 0],
                [1, 0, 0, 0]
            ]
        }];
    return {
        get: function(s, o) {
            var u = s >= 0 && i[s] ? [i[s]] : i;
            return new e.action.role([], 0, 0, 0, o ? o : t, n, r, u || i)
        }
    }
}), define("shine", ["lib/link"], function(e) {
    e.asyncImage([{
        id: "shine",
        src: "images/die.png"
    }]);
    var t = ["shine"],
        n = [
            [
                [0, 20, 101, 64],
                [119, 19, 112, 66],
                [238, 13, 140, 80],
                [391, 0, 103, 100]
            ]
        ],
        r = [{
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 0, -51, -34, 0]
            ]
        }, {
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 1, -54, -34, 0]
            ]
        }, {
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 2, -58, -35, 0]
            ]
        }, {
            aR: [-15, -30, 30, 30],
            bR: [-10, -25, 20, 20],
            fA: [
                [0, 3, -49, -45, 0]
            ]
        }],
        i = [{
            loop: !1,
            frames: [
                [0, 0, 0, 0],
                [1, 0, 0, 0],
                [2, 0, 0, 0],
                [3, 0, 0, 0]
            ]
        }];
    return {
        get: function(s, o) {
            var u = s >= 0 && i[s] ? [i[s]] : i;
            return new e.action.role([], 0, 0, 0, o ? o : t, n, r, u || i)
        }
    }
}), define("index", ["lib/link", "lib/action", "host0", "host1", "shine"], function(e, t, n1, n2, r) {
    return {
        init: function() {
            var t = Date.now(),
                i, s, o = 640,
                u;
            e.canvas.screen.getTouch() ? (i = window.innerWidth, s = window.innerHeight, e.canvas.screen.setWidth(i).setHeight(s), u = s - o >> 1) : (window.onresize = function() {
                i = window.innerWidth, s = window.innerHeight, e.canvas.screen.setWidth(i).setHeight(s), u = s - o >> 1
            }, window.onresize());
            var a = function(e, t) {
                var n = ~~ (e / 1e3 % 1 * 1e3);
                return n == 0 ? n = "000" : n < 100 && (n += "0"), ~~ (e / 1e3) + "." + n + (t || '"')
            };
            e.run(function() {
                var t = Date.now();
                e.canvas.fillStyle("#f6f5d9").fillScreen();
                var n = ~~ (o / l.scenes.length - 60);
                if (!l.died) {
                    l.time = t - l.date;
                    for (var s = 0, f; f = l.scenes[s]; s++) {
                        f.action(0, u + (s + 1) * n, i, n, -8).render();
                        if (f.hostDied) {
                            l.died = !0, l.dieDate = Date.now(), l.shine = r.get(0).mark(f.host.x, f.host.y - 20).setStep(2);
                            break
                        }
                    }
                } else {
                    for (var s = 0, f; f = l.scenes[s]; s++)
                        f.host.action(), f.render();
                    l.shine && (l.shine.action().render(), l.shine.getSprite().endFrame() && (l.shine = null)), t - l.dieDate >= l.dieTimeout && (l.dieDate = null, h())
                }
                var c = a(l.time);
                e.canvas.fillStyle("#ee3314").font("30px Arial").fillText(c, i - e.canvas.measureText(c).width - 20, 50), t = null
            }).menu(function() {
                //click Event
                e.canvas.fillStyle("#F4ECD7").
                fillScreen().drawImage("logo", i - 480 >> 1, u)
                .drawImage("btns1", 0, 99, 480, 7, i - 480 >> 1, u + 280, 480, 7)
                .drawImage("btns1", 0, 99, 480, 7, i - 480 >> 1, u + 540, 480, 7);
                
                if(e.buttonLayout.released("difficulty1")) {
                    l.moduleName = "我的成绩", hideAd(), c(2);
                }

                if(e.buttonLayout.released("difficulty2")) {
                    l.moduleName = "噩梦模式", c(3);
                }

                if(e.buttonLayout.released("difficulty3")) {
                    l.moduleName = "地狱模式", c(4);
                }

                if(e.buttonLayout.released("difficulty4")) {
                    l.moduleName = "炼狱模式", c(5);
                }

                if(e.buttonLayout.released("shareButton")) {
                    shareGame();
                }

            }).zone(function() {
                e.canvas.fillStyle("#f4ecd7").
                fillScreen().
                fillStyle("#495c1a").
                drawString(l.moduleName, 0, u + 110, e.graphics.VCENTER, !1, null, null, "50px 微软雅黑")
                .drawImage("btns1", 0, 106, 480, 7, i - 480 >> 1, u + 140, 480, 7)
                .drawImage("btns1", 0, 106, 480, 7, i - 480 >> 1, u + 555, 480, 7)
                .fillStyle("#ee3314")
                .drawString(a(l.time, "秒"), 0, u + 340, e.graphics.VCENTER, !1, null, null, "60px 微软雅黑")
                .fillStyle("#541510")
                .drawString("最佳:" + a(l.bestTime, "秒"), 0, u + 400, e.graphics.VCENTER, !1, null, null, "30px 微软雅黑"), l.time > l.bestTime && e.canvas.fillStyle("#ee3314").drawString("新纪录", 0, u + 240, e.graphics.VCENTER, !1, null, null, "50px 微软雅黑") && shareGame(l.time / 1000);
            }).events.mouseDown(function(e, t, n) {
                if (l.died)
                    return !1;
                for (var r = 0, i; i = l.scenes[r]; r++)
                    i.touchStart(t, n)
            }).touchStart(function(e, t, n) {
                if (l.died)
                    return !1;
                for (var r = 0, i; i = l.scenes[r]; r++)
                    i.touchStart(t, n)
            });
            var f = function() {
                showAd();
                e.buttonLayout.clear();
                var buttonX = 360;
                if(product == 'baidubrowser') {
                    buttonX = 320;
                    e.buttonLayout.create({
                        id: "shareButton",
                        value: "分享游戏",
                        x: i - 272 >> 1,
                        y: u + 420,
                        width: 272,
                        height: 80,
                        font: "36px 微软雅黑",
                        imageId: "btns1",
                        sx: 0,
                        sy: 0,
                        color: "#FFF",
                        hx: 272,
                        hy: 0,
                        hColor: "#FFF",
                        dex: 272,
                        dey: 0,
                        deColor: "#000"
                    });
                }

                e.buttonLayout.create({
                    id: "difficulty1",
                    value: "开始游戏",
                    x: i - 272 >> 1,
                    y: u + buttonX,
                    width: 272,
                    height: 80,
                    font: "36px 微软雅黑",
                    imageId: "btns1",
                    sx: 0,
                    sy: 0,
                    color: "#FFF",
                    hx: 272,
                    hy: 0,
                    hColor: "#FFF",
                    dex: 272,
                    dey: 0,
                    deColor: "#000"
                }).base().gameFlow.menu();
            };
            f();
            var l = {
                    moduleName: "",
                    module: 0,
                    time: 0,
                    bestTime: 0,
                    date: null,
                    died: !1,
                    dieTimeout: 1e3,
                    dieDate: null,
                    scenes: [],
                    shine: null,
                    Scene: e.extend(function(t) {
                        var n = t%2 ? n2 : n1;
                        this.id = t, this.x = 0, this.baseY = 0, this.width = 0, this.height = 0, this.host = n.get().setStep(2), this.hostDied = !1, this.boxes = [], this.displayDate = Date.now(), this.displayTimeout = e.comm.getRandom(1e3, 2e3)
                    }, null, {
                        render: function() {
                            e.canvas.fillStyle("#9cb154").fillRect(this.x, this.baseY - 5, this.width, 5);
                            for (var t = this.boxes.length - 1, n; n = this.boxes[t]; t--)
                                e.canvas.fillRect(n.x, n.y, n.width, n.height);
                            return this.host.render(), this
                        },
                        action: function(t, n, r, i, s) {
                            this.x = t, this.baseY = n, this.width = r, this.height = i;
                            if (!this.hostDied) {
                                this.host.endPath() && this.host.mark(this.x + 100, this.baseY - 5);
                                var o = Date.now();
                                if (o - this.displayDate >= this.displayTimeout) {
                                    this.displayDate = o;
                                    var u = e.comm.getRandom(5, 30),
                                        a = e.comm.getRandom(10, 50);
                                    this.boxes.unshift({
                                        x: this.width,
                                        y: 0,
                                        width: u,
                                        height: a
                                    }), this.displayTimeout = e.comm.getRandom(1e3, 3e3), u = a = null
                                }
                                for (var f = this.boxes.length - 1, l; l = this.boxes[f]; f--)
                                    l.x += s, l.y = this.baseY - 5 - l.height, this.host.collisionInput(l.x, l.y, l.width, l.height, "bR") && (this.hostDied = !0, this.host.clearPath()), (l.x <= -l.width || l.x >= this.width) && this.boxes.splice(f, 1);
                                o = null
                            }
                            return this.host.action(), this
                        },
                        touchStart: function(t, n) {
                            return this.host.endPath() ? (e.comm.collision(t, n, 1, 1, this.x, this.baseY - this.height, this.width, this.height) && this.host.setPath([
                                [0, -20],
                                [0, -20],
                                [0, -20],
                                [0, -10],
                                [0, -10],
                                [0, -10],
                                [0, -5],
                                [0, -5],
                                [0, -5],
                                [0, 5],
                                [0, 5],
                                [0, 5],
                                [0, 10],
                                [0, 10],
                                [0, 10],
                                [0, 20],
                                [0, 20],
                                [0, 20]
                            ]), this) : this
                        }
                    })
                },
                c = function(t) {
                    e.buttonLayout.clear().base().gameFlow.run(), l.died = !1, l.scenes = [], l.time = 0, l.date = Date.now(), l.shine = null, l.module = t;
                    for (var n = 0; n < t; n++)
                        l.scenes.push(new l.Scene(n))
                },
                h = function() {
                    var t = i - 480 >> 1;
                    var gameTime = l.time / 1000;
                    document.title = "小鸟跳了" + gameTime + "秒";
                    e.buttonLayout.clear();
                    var buttonX = 190;
                    if(product == 'baidubrowser') {
                        buttonX = 100;
                        e.buttonLayout.create({
                            id: "shareGame",
                            value: "",
                            bgColor: "",
                            bgStroke: "",
                            stroke: "",
                            x: t + 280,
                            y: u + 580,
                            width: 100,
                            height: 80,
                            font: "36px 微软雅黑",
                            imageId: "",
                            sx: 0,
                            sy: 0,
                            color: "yellow",
                            hx: 272,
                            hy: 0,
                            hColor: "#AAA",
                            dex: 272,
                            dey: 0,
                            deColor: "#CCC"
                        });
                    }

                    e.buttonLayout.create({
                        id: "wxshare",
                        value: "",
                        bgColor: "",
                        bgStroke: "",
                        stroke: "",
                        x: 300,
                        y: u + 580,
                        width: 100,
                        height: 80,
                        font: "36px 微软雅黑",
                        imageId: "",
                        sx: 0,
                        sy: 0,
                        color: "#FFF",
                        hx: 272,
                        hy: 0,
                        hColor: "#AAA",
                        dex: 272,
                        dey: 0,
                        deColor: "#CCC"
                    }).base().gameFlow.zone();

                    var n = e.localStorage.getItem("NotDieAnyoneBestTime" + l.module);
                    n == null && (n = "0"), l.bestTime = parseInt(n), l.time > l.bestTime && e.localStorage.setItem("NotDieAnyoneBestTime" + l.module, l.time.toString()), submitScore((l.time - 1) / 1000, (l.bestTime - 1) / 1000)
                }
        }
    }
}), require.config({
    baseUrl: "js"
}), require(["lib/link", "index"], function(e, t) {
    e.init(window.innerWidth, window.innerHeight).pushImage([{
        id: "logo",
        src: "images/logo.png"
    }, {
        id: "btns1",
        src: "images/btn.png"
    }], function(e, t, n) {}).initAudio([{
        id: "1",
        src: "sound/1.mp3",
        preload: !0
    }]).loadingCallBack(function(e, t) {}).main(function() {
        t.init()
    })
}), define("main", function() {});