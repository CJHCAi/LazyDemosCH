function rtalt() {
 0 == window.orientation && (-1 == navigator.userAgent.indexOf("Android") || 425 > window.innerHeight && 2 > window.devicePixelRatio) && setTimeout(scrollTo, 100, 0, 1)
}
function didShare(e, t) {
 var n = new Date;
 n.setDate(n.getDate() + 730);
 switch (Math.floor(e)) {
 case 1:
  document.cookie = "st_kma_tip=1; expires=" + n.toGMTString();
  tipon = gtips = 1;
  break;
 case 2:
  document.cookie = "st_kma_run=2; expires=" + n.toGMTString();
  gmsts = 2;
  break;
 case 3:
  document.cookie = "st_kma_run=3; expires=" + n.toGMTString(), gmsts = 3
 }
}
function lcir(e, t) {
 for (var n = 0, r = 0, i = 0, n = 0; 12 > n; n++) r = ldri + n, 12 < r && (r -= 12), ctx.beginPath(), ctx.lineWidth = 2, ctx.strokeStyle = "#FFFFFF", ctx.globalAlpha = r / 10, ctx.moveTo(e + 8 * Math.cos(i), t + 8 * Math.sin(i)), ctx.lineTo(e + 15 * Math.cos(i), t + 15 * Math.sin(i)), ctx.stroke(), i += .5225;
 ctx.globalAlpha = 1;
 ldri--;
 1 > ldri && (ldri = 12)
}
function lding() {
 ctx.clearRect(0, 0, 320, 616);
 ctx.globalAlpha = .6;
 ctx.fillStyle = "#000";
 ctx.fillRect(0, 0, 320, 616);
 ctx.globalAlpha = 1;
 lcir(160, 292)
}
function srt(e, t) {
 e.sort(function(e, n) {
  return e[t] - n[t]
 });
 return e
}
function ralp2() {
 lps += ranlp;
 1 < lps && 1 == alp && (lps--, lp())
}
function ralp() {
 ralp2();
 window.requestAnimationFrame(ralp)
}
function gst() {
 clearInterval(ldlp);
 ctx.clearRect(0, 0, 320, 616);
 spt2(127, 56, 272);
 setTimeout(scrollTo, 200, 0, 1);
 s = 0
}
function gsts() {
 gldt++;
 3 < gldt && setTimeout("gst();", 120)
}
function asd2() {
 document.getElementById("bspc").innerHTML = null;
 document.getElementById("bspc").style.display = "none"
}
function asd() {
 var e = 1 / window.devicePixelRatio,
     t = document.createElement("meta"),
     e = Math.floor(screen.width / 3.2) / 100 * e;
 t.setAttribute("name", "viewport");
 t.setAttribute("content", "width = device-width, initial-scale = " + e + ", minimum-scale = " + e + ", maximum-scale = " + e);
 document.getElementsByTagName("head")[0].appendChild(t);
 setTimeout("asd2", 300)
}
function scs(e, t, n) {
 e = String(e);
 var r = e.length - 1;
 switch (t) {
 case 1:
  for (scx = 0; scx <= r; scx++) t = Math.floor(e.substr(scx, 1)), spt2(68 + t, scrux[4 - r + scx], n)
 }
}
function scs2(e, t, n) {
 e = ("0000000000" + n).substr(-9, 9);
 for (scx = 0; scx < t; scx++) n = Math.floor(e.substr(9 - scx - 1, 1)), spt2(130 + n, 216 - 21 * scx, 270)
}
function spt(e, t, n, r, i) {
 var s = iw[e],
     o = ih[e],
     u = s * r;
 r *= o;
 ctx.drawImage(img7, ix[e], iy[e], s, o, t - u / 2 | 0, n - r * i | 0, u | 0, r | 0)
}
function spt5(e, t, n, r, i) {
 var s = iw[e],
     o = ih[e],
     u = s * r;
 r *= o * r;
 ctx.drawImage(img7, ix[e], iy[e], s, o, t - u / 2 | 0, n - r * i | 0, u | 0, r | 0)
}
function spt2(e, t, n) {
 var r = iw[e],
     i = ih[e];
 ctx.drawImage(img7, ix[e], iy[e], r, i, t | 0, n | 0, r, i)
}
function spt3(e, t, n, r, i) {
 var s = iw[e],
     o = ih[e];
 r *= s;
 i *= o;
 ctx.drawImage(img7, ix[e], iy[e], s, o, t - r / 2 | 0, n - i | 0, r | 0, i | 0)
}
function spt4(e, t, n, r, i) {
 ctx.drawImage(img7, ix[e], iy[e], iw[e], ih[e], t, n, r, i)
}
function init() {
 s = -1;
 var e;
 e = navigator.userAgent;
 dvid = 0; - 1 < e.indexOf("Android") && (dvid = 1, 4 <= Math.floor(navigator.userAgent.substr(e.indexOf("Android") + 8, 1)) && (dvid = 2)); - 1 < e.indexOf("iPad") && (dvid = 3); - 1 < e.indexOf("iPhone") && (dvid = 4, 2 <= window.devicePixelRatio && (dvid = 5, 568 == window.screen.height && (dvid = 5)));
 wdpr = 1;
 chf2.innerHTML = '<canvas id="gcvs" width="320" height="616"></canvas>';
 canvas = document.getElementById("gcvs");
 ctx = canvas.getContext("2d");
 ctx.globalAlpha = .6;
 ctx.fillStyle = "#000";
 ctx.fillRect(0, 0, 320, 616);
 canvas.addEventListener("touchstart", tev1, !1);
 canvas.addEventListener("touchend", tev2, !1);
 canvas.addEventListener("touchmove", tev3, !1);
 canvas.addEventListener("touchcancel", tev4, !1);
 canvas.addEventListener("gesturestart", tev4, !1);
 canvas.addEventListener("gesturechange", tev4, !1);
 canvas.addEventListener("gestureend", tev4, !1);
 canvas.addEventListener("mousedown", tev11, !1);
 canvas.addEventListener("mouseup", tev22, !1);
 canvas.addEventListener("mousemove", tev33, !1);
 gldt = 0;
 e = navigator.language; - 1 < document.URL.indexOf("page") ? (e = ["title_3d_nolink.jpg", "bg.jpg", "end_3d_nolink.jpg", "en.png"], canvas.style.backgroundImage = "url(ber/title_3d_nolink.jpg)", shms1 = "Browser game[Look Bear,Run!] SCORE=", shms2 = "Browser game[Look Bear,Run!]", shms3 = "Why don't you get useful tips by sharing this game to your friends?", shms4 = "Why don't you get useful items by sharing this game to your friends?") : -1 < e.indexOf("ja") ? (e = ["title_3d.jpg", "bg.jpg", "end_3d.jpg", "cs_3d.png"], canvas.style.backgroundImage = "url(ber/title_3d.jpg)", shms1 = "??????V???u???E?U?Q?[???u????I????????v SCORE=", shms2 = "??????V???u???E?U?Q?[???u????I????????v", shms3 = "?F?B?????Q?[?????V?F?A???Â¨!A????TIPS???Q?b?g???o?I", shms4 = "?F?B?????Q?[?????V?F?A???Â¨!A?A?C?e?????Q?b?g???o?I") : (e = ["titl.jpg", "bg.jpg", "end.jpg", "en.png"], canvas.style.backgroundImage = "url(ber/titl.jpg)", shms1 = "Browser game[Look Bear,Run!] SCORE=", shms2 = "Browser game[Look Bear,Run!]", shms3 = "Why don't you get useful tips by sharing this game to your friends?", shms4 = "Why don't you get useful items by sharing this game to your friends?");
 img0 = new Image;
 img0.src = "ber/" + e[0];
 img0.onload = function() {
  gsts()
 };
 img1 = new Image;
 img1.src = "ber/" + e[1];
 img1.onload = function() {
  gsts()
 };
 img2 = new Image;
 img2.src = "ber/" + e[2];
 img2.onload = function() {
  gsts()
 };
 img7 = new Image;
 img7.src = "ber/" + e[3];
 img7.onload = function() {
  gsts()
 };
 stgbg = lps = 0;
 ix = [0, 0, 136, 272, 408, 544, 0, 48, 96, 144, 192, 240, 288, 343, 398, 453, 508, 563, 0, 56, 112, 168, 224, 0, 65, 130, 195, 260, 325, 336, 343, 336, 354, 372, 336, 354, 372, 304, 327, 350, 325, 280, 0, 0, 0, 618, 0, 76, 152, 228, 0, 0, 0, 564, 336, 345, 354, 363, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 548, 560, 572, 584, 596, 608, 620, 632, 644, 656, 668, 623, 564, 621, 731, 761, 791, 821, 731, 761, 791, 0, 640, 0, 320, 735, 783, 839, 623, 304, 390, 0, 272, 680, 680, 680, 691, 691, 691, 691, 691, 691, 735, 735, 735, 735, 544, 503, 640, 640, 640, 640, 640, 640, 691, 801, 735, 0, 503, 691, 0, 0, 640, 661, 682, 703, 724, 745, 766, 787, 808, 829, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 850, 735, 835, 851];
 iy = [0, 0, 0, 0, 0, 0, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 372, 372, 372, 372, 372, 309, 309, 309, 309, 309, 309, 372, 372, 392, 392, 392, 410, 410, 410, 428, 428, 428, 309, 372, 0, 0, 0, 177, 428, 428, 428, 428, 0, 0, 0, 383, 382, 382, 382, 382, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 425, 425, 425, 425, 425, 425, 425, 425, 425, 425, 425, 330, 309, 309, 332, 332, 332, 332, 371, 371, 371, 0, 883, 523, 523, 271, 271, 271, 401, 453, 309, 939, 939, 0, 110, 220, 470, 518, 566, 614, 662, 710, 171, 201, 231, 250, 939, 309, 456, 506, 556, 606, 656, 706, 758, 758, 100, 0, 425, 413, 0, 0, 853, 853, 853, 853, 853, 853, 853, 853, 853, 853, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 853, 0, 0, 332];
 iw = [0, 136, 136, 136, 136, 136, 48, 48, 48, 48, 48, 48, 55, 55, 55, 55, 55, 55, 56, 56, 56, 56, 56, 65, 65, 65, 65, 65, 65, 7, 7, 18, 18, 18, 18, 18, 18, 23, 23, 23, 65, 56, 0, 0, 0, 55, 76, 76, 76, 76, 0, 0, 0, 45, 9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 11, 108, 57, 46, 30, 30, 30, 30, 30, 30, 30, 0, 277, 320, 320, 48, 56, 54, 63, 310, 113, 272, 272, 55, 55, 55, 234, 234, 234, 234, 234, 234, 164, 153, 111, 178, 272, 61, 51, 51, 51, 51, 51, 51, 110, 110, 194, 0, 45, 202, 0, 0, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 100, 32, 44];
 ih = [0, 177, 177, 177, 177, 177, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 56, 56, 56, 56, 56, 63, 63, 63, 63, 63, 63, 10, 10, 18, 18, 18, 18, 18, 18, 19, 19, 19, 63, 56, 0, 0, 0, 132, 95, 95, 95, 95, 0, 0, 0, 35, 9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 71, 74, 19, 39, 39, 39, 39, 39, 39, 39, 0, 56, 616, 616, 61, 61, 61, 24, 70, 139, 65, 65, 110, 110, 110, 48, 48, 48, 48, 48, 48, 30, 30, 19, 21, 65, 116, 50, 50, 50, 50, 50, 50, 95, 95, 71, 0, 13, 57, 0, 0, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25, 100, 32, 44];
 m = 10;
 w = Array(m);
 tx = Array(m);
 ty = Array(m);
 tt = Array(m);
 tf = Array(m);
 ta = Array(m);
 tl = Array(m);
 ts = Array(m);
 tj = Array(m);
 tjy = Array(m);
 trf = Array(m);
 usi = [];
 iszx = [56, 65];
 iszy = [56, 63];
 istx = [0, 280];
 isty = [177, 177];
 for (e = 0; e < m; e++) tx[e] = Math.floor(220 * Math.random()) + 50, ty[e] = 500, tt[e] = Math.floor(2 * Math.random()), ta[e] = 1, tf[e] = 0, tl[e] = 0, ty[e] = 417, ts[e] = 12, 1 < e && usi.push(e), w["c" + e] = {
  i: e,
  y: 500
 };
 knmf = [18, 19, 20, 21, 22, 41];
 ary = Array(3);
 arw = Array(3);
 arh = Array(3);
 ara = Array(3);
 askb = 0;
 e = document.URL.substr(0, 19);
 for (var t = n = 0, n = 7; 19 > n; n++) t += e.charCodeAt(n);
 askb = 1;
 ary[0] = [-46, -53, -60, -68, -75, -82, -89, -96, -103, -103, -103, -103, -103, -103, -103, -103, -103, -103, -103];
 arw[0] = [1.41, 1.46, 1.51, 1.56, 1.61, 1.65, 1.7, 1.75, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8];
 arh[0] = [1.37, 1.43, 1.48, 1.53, 1.59, 1.64, 1.69, 1.75, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8];
 ara[0] = [.89, .78, .67, .55, .45, .33, .22, .11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
 ary[1] = [-10, -20, -31, -41, -51, -61, -72, -82, -92, -92, -92, -92, -92, -92, -92, -92, -92, -92, -92];
 arw[1] = [1.06, 1.12, 1.18, 1.24, 1.3, 1.36, 1.41, 1.47, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53];
 arh[1] = [1.06, 1.12, 1.18, 1.24, 1.3, 1.36, 1.41, 1.47, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53, 1.53];
 ara[1] = [.89, .78, .67, .55, .45, .33, .22, .11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
 ary[2] = [-143, -151, -158, -165, -172, -180, -187, -194, -201, -201, -201, -201, -201, -201, -201, -201, -201, -201, -201];
 arw[2] = [2.75, 2.77, 2.8, 2.82, 2.84, 2.86, 2.88, 2.9, 2.92, 2.92, 2.92, 2.92, 2.92, 2.92, 2.92, 2.92, 2.92, 2.92, 2.92];
 arh[2] = [2.18, 2.16, 2.14, 2.12, 2.1, 2.08, 2.07, 2.05, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03];
 ara[2] = [.89, .78, .67, .55, .45, .33, .22, .11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
 ary[3] = [-83, -96, -109, -123, -136, -149, -163, -176, -189, -189, -189, -189, -189, -189, -189, -189, -189, -189, -189];
 arw[3] = [3.03, 3.19, 3.36, 3.52, 3.68, 3.84, 4.01, 4.17, 4.33, 4.33, 4.33, 4.33, 4.33, 4.33, 4.33, 4.33, 4.33, 4.33, 4.33];
 arh[3] = [1.55, 1.7, 1.85, 2, 2.16, 2.31, 2.46, 2.61, 2.77, 2.77, 2.77, 2.77, 2.77, 2.77, 2.77, 2.77, 2.77, 2.77, 2.77];
 ara[3] = [.89, .78, .67, .55, .45, .33, .22, .11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
 glv = [55, 55, 55, 50, 50, 45, 40, 35, 30, 55, 30, 20, 12, 11, 10, 9, 8, 20];
 gsp = [10, 10, 10, 11, 11, 11, 12, 13, 14, 11, 13, 14, 15, 16, 17, 17, 17, 12];
 gcl = [0, 0, 0, 200, 300, 450, 200, 200, 200, 400, 300, 300, 300, 500, 500, 600, 500, 999];
 gkk = [-99, -99, -99, -99, -99, -99, -99, -99, -99, 70, 40, 50, 60, 70, 80, 80, 80, -99];
 fani = Array(4);
 fani[0] = [0, 0, 0, 8, 19, 0, 0, -5, .33, 8, 14, .33, 0, -10, .67, 8, 9, .67, 0, -15, 1, 8, 4, 1, 0, -13, 1, 8, 6, 1, 0, -11, 1, 8, 8, 1, 0, -10, 1, 8, 9, 1, 0, -10, 1, 8, 9, 1, 0, -10, .8, 8, 9, .8, 0, -10, .6, 8, 9, .6, 0, -10, .4, 8, 9, .4, 0, -10, .2, 8, 9, .2, 0, -10, 0, 8, 9, 0];
 fani[1] = [0, 355, 0, 0, 351, .36, 0, 349, .64, 0, 347, .84, 0, 345, .96, 0, 345, 1, 0, 348, 1, 0, 355, 1, 0, 352, 1, 0, 351, 1, 0, 350, 1, 0, 353, 1, 0, 355, 1, 0, 355, 1, 0, 355, 1, 0, 355, 1, 0, 355, 1, 0, 355, 1, 0, 355, 1, 0, 351, 1, 0, 349, 1, 0, 347, 1, 0, 345, 1, 0, 345, 1, 0, 348, 1, 0, 355, 1, 0, 352, 1, 0, 351, 1, 0, 350, 1, 0, 353, 1, 0, 355, 1, 0, 355, 1, 0, 355, 1, 0, 355, 1, 0, 355, 1, 0, 355, 1, 0, 355, .88, 0, 355, .75, 0, 355, .63, 0, 355, .5, 0, 355, .38, 0, 355, .25, 0, 355, .13, 0, 355, 0, 0, 355, 0];
 fa_f = {};
 fani[2] = [19, -57, 1, 19, -54, 1, 19, -47, 1, 19, -34, 1, 19, -16, 1, 19, 7, 1, 19, 2, 1, 19, 0, 1, 19, 2, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, 1, 19, 3, .88, 19, 3, .75, 19, 3, .63, 19, 3, .5, 19, 3, .38, 19, 3, .25, 19, 3, .13, 19, 3, 0];
 fa_fi = 0;
 fani2 = [321, -56, 0, 104, 125, -50, -56, 0, 104, 125, -58, -87, .7, 120, 148, 321, -56, 0, 104, 125, -51, -60, .1, 106, 129, -60, -92, .6, 122, 151, 321, -56, 0, 104, 125, -53, -65, .2, 108, 132, -61, -96, .5, 125, 155, 321, -56, 0, 104, 125, -54, -69, .3, 111, 135, -63, -101, .4, 127, 158, 321, -56, 0, 104, 125, -56, -74, .4, 113, 138, -65, -106, .3, 130, 161, 321, -56, 0, 104, 125, -57, -78, .5, 115, 142, -67, -111, .2, 132, 164, 321, -56, 0, 104, 125, -59, -83, .6, 118, 145, -68, -115, .1, 134, 168, -48, -56, 0, 104, 125, -60, -87, .7, 120, 148, -70, -120, 0, 137, 171, -49, -59, .08, 105, 128, -62, -91, .61, 122, 151, -70, -112, 0, 137, 171, -50, -63, .16, 107, 130, -63, -95, .52, 124, 153, -70, -112, 0, 137, 171, -51, -67, .24, 109, 133, -65, -99, .44, 126, 156, -70, -112, 0, 137, 171, -52, -70, .32, 111, 136, -66, -103, .35, 128, 159, -70, -112, 0, 137, 171, -54, -74, .4, 113, 138, -68, -108, .26, 130, 161, -70, -112, 0, 137, 171, -55, -77, .48, 115, 141, -69, -112, .18, 132, 164, -70, -112, 0, 137, 171, -56, -81, .56, 117, 143, -71, -116, .09, 133, 166, -70, -112, 0, 137, 171, -57, -84, .64, 119, 146, -72, -120, 0, 135, 169, -70, -112, 0, 137, 171];
 fanf2 = [47, 46, 47];
 fafi2 = 0;
 fani3 = [210, 30, 0, 210, 37, .44, 210, 41, .75, 210, 44, .94, 210, 45, 1, 210, 43, 1, 210, 42, 1, 210, 43, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, 1, 210, 45, .88, 210, 45, .75, 210, 45, .63, 210, 45, .5, 210, 45, .38, 210, 45, .25, 210, 45, .13, 210, 45, 0];
 fani4 = [5, 150, 0, 106, 151, 0, 321, 72, 1, 5, 150, .11, 106, 151, .2, 321, 72, 1, 5, 150, .22, 106, 151, .4, 321, 72, 1, 5, 150, .33, 106, 151, .6, 321, 72, 1, 5, 150, .45, 106, 151, .8, 321, 72, 1, 5, 150, .55, 106, 151, 1, 179, 67, 0, 5, 150, .67, 101, 151, 1, 188, 67, .36, 5, 150, .78, 96, 151, 1, 196, 67, .64, 5, 150, .89, 91, 151, 1, 201, 67, .84, 5, 150, 1, 86, 151, 1, 204, 67, .96, 5, 150, 1, 81, 151, 1, 205, 67, 1, 5, 150, 1, 77, 151, 1, 201, 67, 1, 5, 150, 1, 72, 151, 1, 189, 67, 1, 5, 150, 1, 67, 151, 1, 195, 67, 1, 5, 150, 1, 62, 151, 1, 197, 67, 1, 5, 150, 1, 57, 151, 1, 197, 67, 1, 5, 150, 1, 52, 151, 1, 197, 67, 1, 5, 150, 1, 57, 151, 1, 197, 67, 1, 5, 150, 1, 62, 151, 1, 197, 67, 1, 5, 150, 1, 67, 151, 1, 197, 67, 1, 5, 150, 1, 72, 151, 1, 197, 67, 1, 5, 150, 1, 77, 151, 1, 197, 67, 1, 5, 150, 1, 81, 151, 1, 197, 67, 1, 5, 150, 1, 86, 151, 1, 197, 67, 1, 5, 150, 1, 91, 151, 1, 197, 67, 1, 5, 150, 1, 96, 151, 1, 197, 67, 1, 5, 150, 1, 101, 151, 1, 197, 67, 1, 5, 150, 1, 106, 151, 1, 197, 67, 1, 5, 150, 1, 110, 151, 1, 197, 67, 1, 5, 150, 1, 115, 151, 1, 197, 67, 1, 5, 150, 1, 119, 151, 1, 197, 67, 1, 5, 150, 1, 123, 151, 1, 197, 67, 1, 5, 150, 1, 128, 151, 1, 197, 67, 1, 5, 150, 1, 132, 151, 1, 197, 67, 1, 5, 150, 1, 137, 151, 1, 197, 67, 1, 5, 150, 1, 141, 151, 1, 197, 67, 1, 5, 150, 1, 145, 151, 1, 197, 67, 1, 5, 150, 1, 150, 151, 1, 197, 67, 1, 5, 150, 1, 154, 151, 1, 197, 67, 1, 5, 150, 1, 150, 151, 1, 197, 67, 1, 5, 150, 1, 145, 151, 1, 197, 67, 1, 5, 150, 1, 141, 151, 1, 197, 67, 1, 5, 150, 1, 137, 151, 1, 197, 67, 1, 5, 150, 1, 132, 151, 1, 197, 67, 1, 5, 150, 1, 128, 151, 1, 197, 67, 1, 5, 150, 1, 123, 151, 1, 197, 67, 1, 5, 150, 1, 119, 151, 1, 197, 67, 1, 5, 150, 1, 115, 151, 1, 197, 67, 1, 5, 150, .94, 110, 151, 1, 197, 67, 1, 5, 150, .88, 106, 151, 1, 197, 67, 1, 5, 150, .81, 106, 151, .93, 197, 67, 1, 5, 150, .75, 106, 151, .86, 197, 67, 1, 5, 150, .69, 106, 151, .79, 197, 67, 1, 5, 150, .63, 106, 151, .71, 197, 67, 1, 5, 150, .56, 106, 151, .64, 197, 67, .9, 5, 150, .5, 106, 151, .57, 197, 67, .8, 5, 150, .44, 106, 151, .5, 197, 67, .7, 5, 150, .38, 106, 151, .43, 197, 67, .6, 5, 150, .31, 106, 151, .36, 197, 67, .5, 5, 150, .25, 106, 151, .29, 197, 67, .4, 5, 150, .19, 106, 151, .21, 197, 67, .3, 5, 150, .13, 106, 151, .14, 197, 67, .2, 5, 150, .06, 106, 151, .07, 197, 67, .1, 5, 150, 0, 106, 151, 0, 197, 67, 0];
 fanf4 = [97, 98, 123];
 fani5 = [24, -66, 1, 24, -63, 1, 24, -53, 1, 24, -38, 1, 24, -16, 1, 24, 12, 1, 24, 8, 1, 24, 6, 1, 24, 8, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 12, 1, 24, 11, 1, 24, 7, 1, 24, 1, 1, 24, -8, 1, 24, -19, 1, 24, -32, 1, 24, -48, 1, 24, -67, 1];
 fani6 = [36, 138, 0, 106, 193, 0, 321, 72, 1, 36, 138, .11, 106, 193, .2, 321, 72, 1, 36, 138, .22, 106, 193, .4, 321, 72, 1, 36, 138, .33, 106, 193, .6, 321, 72, 1, 36, 138, .45, 106, 193, .8, 321, 72, 1, 36, 138, .55, 106, 193, 1, 179, 67, 0, 36, 138, .67, 106, 189, 1, 188, 67, .36, 36, 138, .78, 106, 186, 1, 196, 67, .64, 36, 138, .89, 106, 182, 1, 201, 67, .84, 36, 138, 1, 106, 163, 1, 204, 67, .96, 36, 138, 1, 106, 148, 1, 205, 67, 1, 36, 138, 1, 106, 136, 1, 201, 67, 1, 36, 138, 1, 106, 127, 1, 189, 67, 1, 36, 138, 1, 106, 122, 1, 195, 67, 1, 36, 138, 1, 106, 120, 1, 197, 67, 1, 36, 138, 1, 106, 120, .89, 197, 67, 1, 36, 138, 1, 106, 120, .78, 197, 67, 1, 36, 138, 1, 106, 120, .67, 197, 67, 1, 36, 138, 1, 106, 120, .55, 197, 67, 1, 36, 138, 1, 106, 120, .45, 197, 67, 1, 36, 138, 1, 106, 120, .33, 197, 67, 1, 36, 138, 1, 106, 120, .22, 197, 67, 1, 36, 138, 1, 106, 120, .11, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 120, 0, 197, 67, 1, 36, 138, 1, 106, 193, 0, 197, 67, 1, 36, 138, 1, 106, 193, .2, 197, 67, 1, 36, 138, 1, 106, 193, .4, 197, 67, 1, 36, 138, 1, 106, 193, .6, 197, 67, 1, 36, 138, 1, 106, 193, .8, 197, 67, 1, 36, 138, 1, 106, 193, 1, 197, 67, 1, 36, 138, 1, 106, 189, 1, 197, 67, 1, 36, 138, 1, 106, 186, 1, 197, 67, 1, 36, 138, 1, 106, 182, 1, 197, 67, 1, 36, 138, .94, 106, 163, 1, 197, 67, 1, 36, 138, .88, 106, 148, 1, 197, 67, 1, 36, 138, .81, 106, 136, 1, 197, 67, 1, 36, 138, .75, 106, 127, 1, 197, 67, 1, 36, 138, .69, 106, 122, 1, 197, 67, 1, 36, 138, .63, 106, 120, 1, 197, 67, 1, 36, 138, .56, 106, 120, .89, 197, 67, .9, 36, 138, .5, 106, 120, .78, 197, 67, .8, 36, 138, .44, 106, 120, .67, 197, 67, .7, 36, 138, .38, 106, 120, .55, 197, 67, .6, 36, 138, .31, 106, 120, .45, 197, 67, .5, 36, 138, .25, 106, 120, .33, 197, 67, .4, 36, 138, .19, 106, 120, .22, 197, 67, .3, 36, 138, .13, 106, 120, .11, 197, 67, .2, 36, 138, .06, 106, 120, 0, 197, 67, .1, 36, 138, 0, 106, 120, 0, 197, 67, 0];
 fanf6 = [115, 98, 122];
 fani7 = [157, 56, 10, 4, 1, 125, 44, 75, 27, 1, 98, 34, 128, 47, 1, 77, 27, 170, 62, 1, 62, 22, 199, 73, 1, 53, 18, 217, 80, 1, 50, 17, 223, 82, 1, 65, 22, 194, 71, 1, 70, 24, 184, 67, 1, 66, 22, 192, 70, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 54, 18, 216, 79, 1, 50, 17, 223, 82, 1, 65, 22, 194, 71, 1, 70, 24, 184, 67, 1, 66, 22, 192, 70, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 54, 18, 216, 79, 1, 50, 17, 223, 82, 1, 65, 22, 194, 71, 1, 70, 24, 184, 67, 1, 66, 22, 192, 70, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, 1, 65, 22, 194, 71, .83, 65, 22, 194, 71, .67, 65, 22, 194, 71, .5, 65, 22, 194, 71, .33, 65, 22, 194, 71, .17, 65, 22, 194, 71, 0];
 fani8 = [-6, -199, 2, -138, 8, -88, 13, -50, 17, -22, 19, -6, 20, 0];
 scrux = [232, 245, 258, 271, 284];
 e = document.cookie;
 n = e.indexOf("rvs_3d_run=") + 11;
 10 != n ? (e = e.substr(n, e.indexOf("endcksv") - n), bstscr = Math.floor(e)) : (e = new Date, e.setDate(e.getDate() + 730), document.cookie = "rvs_3d_run=1000endcksv; expires=" + e.toGMTString(), bstscr = 1e3);
 e = document.createElement("canvas");
 e.width = 320;
 e.height = 616;
 bcv2 = e.getContext("2d");
 bex = [136, 139, 138, 139, 138];
 bey = [66, 87, 99, 87, 78];
 e = document.cookie;
 n = e.indexOf("st_kma_run=") + 11;
 gmsts = 0;
 10 != n && (gmsts = Math.floor(e.substr(n, 1)));
 n = e.indexOf("st_kma_tip=") + 11;
 gtips = 0;
 10 != n && 1 == Math.floor(e.substr(n, 1)) && (gtips = 1);
 stini()
}
function stini() {
 gmovcl = tipon = 0;
 stti1 = 2;
 stti2 = 30;
 ranlp = .5;
 ttlct = 760;
 switch (gmsts) {
 case 0:
  stti1 = 2;
  stti2 = 30;
  ranlp = .5;
  ttlct = 0;
  break;
 case 1:
  stti1 = 2;
  stti2 = 30;
  ranlp = .5;
  ttlct = 760;
  break;
 case 2:
  stti1 = 2;
  stti2 = 30;
  ranlp = .5;
  ttlct = 760;
  break;
 case 3:
  stti1 = 2, stti2 = 30, ranlp = .5, ttlct = 760
 }
 gmovf = 0;
 gmovc = 5;
 efc = ef = afc = af = 0;
 tx[0] = 160;
 ty[0] = 200;
 tx[1] = 160;
 ty[1] = 53;
 wx = 160;
 stefc = upx = flt = mt = tm = 0;
 sp = 1;
 bp_f = {};
 bpfr = bp_fi = 0;
 ip_f = {};
 ip_fi = 0;
 rk_f = {};
 rk_fi = 0;
 wd_f = {};
 wd_fi = 0;
 as_f = {};
 brc = arc = mkj = mky = mkt = asfr2 = asfr = as_fi = 0;
 rmx = 285;
 rex = 324;
 mes = esp = msp = 0;
 ttlmd = 1;
 slv = 0;
 uct = -75;
 alp = 1;
 bemy = bemx = ogm = mtitv = kmstt = jsf = jpy = tchy = hsmn = fvra = fvri = fvrc = fvr = spdr2 = spdr1 = spdr = lscr = scr = cmb = bnst = bnsc = gtm = dgt = 0;
 for (var e = 2; e < m; e++) tx[e] = Math.floor(220 * Math.random()) + 50, ty[e] = 500, tt[e] = Math.floor(2 * Math.random()), ta[e] = 1, tf[e] = 0, tl[e] = 0, ty[e] = 417, ts[e] = 12
}
function gtcmb(e, t) {
 pt_set1(e, t, 32);
 cmb++;
 0 == fvr && 1 < cmb && 9 > cmb && (fa_f["c" + fa_fi] = {
  x: tx[0] - 22,
  y: ty[0] - 50,
  fi: 0,
  pi: 0,
  ci: 80 + cmb,
  l: 1
 }, fa_fi++, 8 == cmb && 0 == spdr && (fa_f["c" + fa_fi] = {
  x: Math.floor(200 * Math.random()) + 60,
  y: 355,
  fi: 1,
  pi: 0,
  ci: 0,
  l: 1
 }, fa_fi++, spdr = -1));
 0 == arc && (arc = 1)
}
function tev11(e) {
 mousePos = {
  x: e.layerX,
  y: e.layerY
 };
 Press(mousePos);
 e.preventDefault();
 return false
}
function tev1(e) {
 mousePos = {
  x: e.touches[0].pageX,
  y: e.touches[0].pageY
 };
 Press(mousePos);
 e.preventDefault();
 return false
}
function Press(e) {
 var t = e.x / wdpr | 0;
 switch (s) {
 case 1:
  mv(t);
  if (750 > ttlct) {
   var n = e.y / wdpr | 0;
   235 < t && 70 > n && (ttlct = 751)
  }
  break;
 case 0:
  n = e.y / wdpr | 0;
  175 < t && 365 < n ? window.location.href = HOME_PATH : 60 > t && 350 < n ? setTimeout(function() {
   show_share()
  }, 500) : (stini(), s = 1, 6 != dvid ? stm = setTimeout("lp()", 1e3 / stti2) : (window.requestAnimationFrame = function() {
   return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame ||
   function(e, t) {
    window.setTimeout(e, 1e3 / 60)
   }
  }(), ralp()), canvas.style.backgroundImage = "none");
  break;
 case 2:
  n = e.y / wdpr | 0;
  175 < t && 365 < n ? window.location.href = HOME_PATH : 35 < t && 180 < n && t < 155 && n < 225 ? (scr = 0, stini(), s = 1, d) : 168 < t && 180 < n && t < 286 && n < 225 && setTimeout(function() {
   show_share()
  }, 500)
 }
 e = e.y / wdpr;
 jpy = 0;
 n = e
}
function tev22(e) {
 mousePos = {
  x: e.layerX,
  y: e.layerY
 };
 Release(mousePos);
 e.preventDefault();
 return false
}
function tev2(e) {
 mousePos = {
  x: e.changedTouches[0].pageX,
  y: e.changedTouches[0].pageY
 };
 Release(mousePos);
 e.preventDefault();
 return false
}
function Release(e) {
 10 < jpy && 0 == mkt && (mkt = 21, mky = 0, mkj = -20, jsf = 101)
}
function tev33(e) {
 mousePos = {
  x: e.layerX,
  y: e.layerY
 };
 Move(mousePos)
}
function tev3(e) {
 mousePos = {
  x: e.touches[0].pageX,
  y: e.touches[0].pageY
 };
 Move(mousePos);
 e.preventDefault();
 return false
}
function Move(e) {
 var t = e.y / wdpr;
 jpy = tchy - t;
 tchy = t;
 mv(e.x / wdpr | 0)
}
function tev4(e) {
 e.preventDefault();
 return false
}
function mv(e) {
 wx = mx = .6 * (e - 160) + 160
}
function pt_set1(e, t, n) {
 var r = 0,
     i, s;
 Math.sqrt(Math.pow(void 0, 2) + Math.pow(void 0, 2));
 Math.cos(r);
 Math.sin(r);
 e -= 9;
 t -= 9;
 for (var o = 0; 10 > o; o++) r += .66, i = 8 * Math.cos(r), s = 8 * Math.sin(r), ip_f["c" + ip_fi] = {
  x: e + i,
  y: t + s,
  f: n,
  sx: .4 * i + .2 * Math.random() - .1,
  sy: .01 * s - 1 * Math.random(),
  a: 1,
  l: 1
 }, ip_fi++
}
function pt_set2(e, t, n) {
 n *= 1.4;
 for (var r = 0; 6 > r; r++) rk_f["c" + rk_fi] = {
  x: e,
  y: t,
  ly: t,
  sy2: 0,
  f: 37 + Math.floor(3 * Math.random()),
  sx: (-10 + 3.3 * r) * n,
  sy: (-7 - 3 * Math.random()) * n,
  sc: 1.3 * n,
  l: 1
 }, rk_fi++;
 rk_f["c" + (rk_fi - 4)].sy -= 2 * n;
 rk_f["c" + (rk_fi - 3)].sy -= 2 * n
}
function pt_set3(e, t, n) {
 n *= 1.4;
 for (var r = [110, 111, 112, 113, 113], i = [-8, 10, 2.4, -5.6, -4.8], s = [-6, -6, -10, -5, -8], o = 0; 5 > o; o++) wd_f["c" + wd_fi] = {
  x: e,
  y: t,
  ly: t,
  sy2: 0,
  f: r[o],
  sx: i[o] * n,
  sy: s[o] * n,
  sc: 1.3 * n,
  a: 1,
  l: 1
 }, wd_fi++
}
function lp() {
 6 != dvid && 1 == alp && (clearTimeout(stm), stm = setTimeout("lp()", 1e3 / stti2));
 var e, t, n = 0;
 if (0 == ogm) {
  stgbg += 1 + (0 < fvr);
  4 < stgbg && (stgbg -= 5);
  ctx.drawImage(img1, 320 * stgbg, 0, 320, 616, 0, 0, 320, 616);
  var r = [];
  for (e in w) t = w[e], t.y = Math.floor(ty[t.i]), r.push([t.i, t.y]);
  srt(r, 1);
  tm = Math.floor(+(new Date) / 1e3);
  tm != mt && 1 < tm && (flt = 0, 0 == gmsts && 500 < scr && (e = new Date, e.setDate(e.getDate() + 730), document.cookie = "st_kma_run=1; expires=" + e.toGMTString(), gmsts = 1));
  flt++;
  mt = tm;
  var i, o, u, a = 1;
  0 < fvr && (a = .5);
  for (i = 0; i < r.length; i++) {
   e = r[i][0];
   switch (e) {
   case 0:
    if (0 < ip_fi) {
     u = 0;
     for (var f in ip_f) t = ip_f[f], 1 == t.l && (t.x += t.sx, t.y += t.sy, t.sx *= .85, t.sy -= .3, t.a -= .05, 0 > t.a ? (t.l = 0, delete t) : (ctx.globalAlpha = t.a, spt2(t.f, t.x, t.y), ctx.globalAlpha = 1), u++);
     0 == u && (ip_f = {}, ip_fi = 0)
    }
    if (0 < rk_fi) {
     u = 0;
     for (f in rk_f) t = rk_f[f], 1 == t.l && (t.x += t.sx, t.y += t.sy, t.sx *= .96, t.sy += .8 * t.sc + t.sy2, 2 < t.sy && (t.sc *= .8), t.y > t.ly || .1 > t.sc ? (t.l = 0, delete t) : spt(t.f, t.x, t.y, t.sc, 0), u++);
     0 == u && (rk_f = {}, rk_fi = 0)
    }
    if (0 < wd_fi) {
     u = 0;
     for (f in wd_f) t = wd_f[f], 1 == t.l && (t.x += t.sx, t.y += t.sy, t.sx *= .96, t.sy += 1, 0 < t.sy && (t.a -= .1), 0 > t.a ? (t.a = 0, t.l = 0, delete t) : (ctx.globalAlpha = t.a, spt(t.f, t.x, t.y, t.sc, 0), ctx.globalAlpha = 1), u++);
     0 == u && (wd_f = {}, wd_fi = 0)
    }
    if (0 != fvr) {
     for (t = 0; 3 > t; t++) u = 15 * fafi2 + 5 * t, ctx.globalAlpha = fani2[u + 2], spt4(fanf2[t], fani2[u] + tx[0], fani2[u + 1] + 175, fani2[u + 3], fani2[u + 4]);
     fafi2++;
     15 < fafi2 && (fafi2 = 0);
     ctx.globalAlpha = 1
    }
    afc++;
    1 < afc && (afc = 0, af++, 5 < af && (af = 0));
    tx[e] += (wx - tx[e]) / 3;
    80 > tx[e] && (tx[e] = 80);
    240 < tx[e] && (tx[e] = 240);
    upx = tx[e];
    u = af + 6;
    160 < ty[1] && (n = .5, u = af + 12, asfr++, 8 < asfr && (asfr = 0, as_f["c" + as_fi] = {
     x: tx[e] + 10 - 4,
     y: ty[e] - 80,
     sx: 2 + 5 * Math.random(),
     sy: -3 - 5 * Math.random(),
     f: 56 + Math.floor(2 * Math.random()),
     a: 1,
     l: 1
    }, as_fi++, as_f["c" + as_fi] = {
     x: tx[e] + 5 - 4,
     y: ty[e] - 80,
     sx: 0 + 5 * Math.random(),
     sy: -5 - 5 * Math.random(),
     f: 56 + Math.floor(2 * Math.random()),
     a: 1,
     l: 1
    }, as_fi++, as_f["c" + as_fi] = {
     x: tx[e] - 10 - 4,
     y: ty[e] - 80,
     sx: -2 - 5 * Math.random(),
     sy: -3 - 5 * Math.random(),
     f: 54 + Math.floor(2 * Math.random()),
     a: 1,
     l: 1
    }, as_fi++, as_f["c" + as_fi] = {
     x: tx[e] - 5 - 4,
     y: ty[e] - 80,
     sx: -0 - 5 * Math.random(),
     sy: -5 - 5 * Math.random(),
     f: 54 + Math.floor(2 * Math.random()),
     a: 1,
     l: 1
    }, as_fi++));
    if (0 < mkt) {
     u = jsf;
     t = mkj;
     if (45 != jsf) {
      switch (mkt) {
      case 16:
       103 != jsf && (jsf = 102);
       break;
      case 8:
       jsf = 103
      }
      t = .7 * mkj
     }
     mky += t;
     mkj += 2;
     0 < mky && (mky = 0, mkj = -mkj / 2);
     mkt--;
     0 == mkt && (mkj = mky = 0);
     spt2(53, tx[e] - 24, ty[e])
    }
    0 < arc ? (ctx.globalAlpha = ara[0][arc], spt3(46, tx[e], ty[e] + ary[0][arc] + 130, arw[0][arc], arh[0][arc]), ctx.globalAlpha = 1, spt(u, tx[e], ty[e] + mky, 1, .7), ctx.globalAlpha = ara[1][arc], spt3(47, tx[e], ty[e] + ary[0][arc] + 130, arw[0][arc], arh[0][arc]), ctx.globalAlpha = 1, arc++, 10 < arc && (arc = 0)) : spt(u, tx[e], ty[e] + mky, 1, .7);
    if (0 < as_fi) {
     u = 0;
     for (f in as_f) t = as_f[f], 1 == t.l && (t.x += t.sx, t.y += t.sy, t.sx *= .96, t.sy += 1.2, t.a -= .1, 0 > t.a ? (t.l = 0, delete t) : (ctx.globalAlpha = t.a, spt2(t.f, t.x, t.y), ctx.globalAlpha = 1), u++);
     0 == u && (as_f = {}, as_fi = 0)
    }
    break;
   case 1:
    efc++;
    2 < efc && (efc = 0, ef++, 4 < ef && (ef = 0));
    stefc += kmstt;
    30 < stefc && 60 > stefc && (rex += (rmx + 3 - rex) / 6);
    ty[e] += (195 - 4.833 * mes - ty[e]) / 10;
    50 > ty[e] && (ty[e] = 50);
    195 < ty[e] && (ty[e] = 195);
    u = (ty[e] - 50) / 130;
    o = (ty[e] - 40) / 336;
    t = (tx[e] - 160) * o + 164;
    o = ty[e] - o / 2;
    75 > o && (o = 75);
    120 > ty[e] && (ctx.globalAlpha = ty[e] * ty[e] * ty[e] / 1e4 * (1 / 120));
    0 < brc ? (ctx.globalAlpha = ara[2][brc], spt3(48, t, o + ary[2][brc] * u + 200 * u, arw[2][brc] * u * 1, arh[2][brc] * u * 1), ctx.globalAlpha = 1, spt(ef + 1, t, o, u, .83), ctx.globalAlpha = ara[3][brc], spt3(49, t, o + ary[3][brc] * u + 170 * u, arw[3][brc] * u * 1, arh[3][brc] * u * 1), ctx.globalAlpha = 1, brc++, 10 < brc && (brc = 0)) : spt(ef + 1, t, o, u, .83);
    bemx = t;
    bemy = o;
    ctx.globalAlpha = 1;
    if (0 < bp_fi) {
     o = 0;
     for (f in bp_f) t = bp_f[f], 1 == t.l && (ctx.globalAlpha = t.a, spt2(t.f, t.x, t.y), ctx.globalAlpha = 1, t.x += t.sx, t.y += t.sy, t.sy -= .1, t.a -= .05, 0 > t.a && (t.l = 0, delete t), o++);
     0 == o && (bp_f = {}, bp_fi = 0)
    }
    bpfr++;
    t = ef + 1;
    t > ef && t - 4;
    (1 == ef || 3 == ef) && 0 < bpfr && 150 < ty[e] && (bpfr = 0, bp_f["c" + bp_fi] = {
     x: tx[e] + 5,
     y: ty[e] - 60 * u,
     sx: 0 * Math.random() - 0,
     sy: 3.8 * u,
     f: 29 + Math.floor(2 * Math.random()),
     a: 1,
     l: 1
    }, bp_fi++);
    break;
   default:
    if (1 == tl[e]) {
     u = (ty[e] - 50) / (236 + .09 * (1800 - ty[e]));
     ty[e] -= ts[e] * u;
     o = (ty[e] - 40) / 336;
     t = (tx[e] - 160) * o + 160;
     o = ty[e];
     if (115 > ty[e] && (ta[e] -= .05, 0 > ta[e] && (ta[e] = 0), 80 > ty[e])) {
      if (1 == tl[e]) switch (ta[e] = 0, tt[e]) {
      case 0:
       0 == fvr && 0 == ttlmd && (sp += 2, 1.5 < sp && (sp = 1.5), pt_set1(t, o, 35), 0 == brc && (brc = 1), esp = 30 < mes ? esp + 84 : esp + 46);
       break;
      case 2:
       0 == fvr && (pt_set1(t, o, 35), esp = 200), spdr = 0
      }
      tl[e] = 0;
      usi.push(e)
     }
     if (200 < ty[e] && 225 > ty[e] && (25 > Math.abs(t - tx[0]) || 3 == tt[e]) && (7 > mkt || 2 == tt[e]) && 1 == tl[e] && 4 != tt[e]) switch (tl[e] = 0, usi.push(e), tt[e]) {
     case 0:
      gtcmb(t, o);
      msp = 6 > mes ? 12 : 10 > mes ? 10 : 7;
      break;
     case 1:
      pt_set2(t, o, u);
      0 < mkt ? (mkt = 20, mky = -16, mkj = -9, jsf = 103, gtcmb(t, o)) : 0 == fvr ? (cmb = 0, mkt = 16, mky = 0, mkj = -8, jsf = 45, 0 == ttlmd && (24 < mes ? (msp = -600, esp += 50) : 12 < mes ? (msp = -600, esp += 20) : msp = -300, 2500 < scr && (msp -= (scr - 2500) / 100))) : gtcmb(t, o);
      break;
     case 2:
      fa_f["c" + fa_fi] = {
       x: 0,
       y: 0,
       fi: 2,
       pi: 0,
       ci: 0,
       l: 1
      };
      fa_fi++;
      fvr = 1;
      fvrc = 0;
      fvri = 1;
      spdr = fvra = 0;
      2 > slv && (slv = 2);
      break;
     case 3:
      pt_set3(t, o, u), 0 < mkt ? (mkt = 20, mky = -16, mkj = -9, jsf = 103, gtcmb(t, o)) : 0 == fvr ? (cmb = 0, mkt = 16, mky = 0, mkj = -8, jsf = 45, 0 == ttlmd && (24 < mes ? (msp = -600, esp += 50) : 12 < mes ? (msp = -600, esp += 20) : msp = -300, 2500 < scr && (msp -= (scr - 2500) / 100))) : gtcmb(t, o)
     } else if (1 == tl[e] && ty[e] < ty[1] + 10 && 4 != tt[e]) {
      var l = 0;
      switch (tt[e]) {
      case 0:
       0 == fvr && (pt_set1(t, o, 35), 0 == brc && (brc = 1), esp = 15 < mes ? 36 : 6 < mes ? 24 : 10, 2500 < scr && (esp += (scr - 2500) / 100));
       break;
      case 1:
       100 * Math.random() > gkk[slv] ? (pt_set2(t, o, u), esp = 12 < mes ? -20 : -200, 2200 < scr && (esp = -20)) : (l = 1, ts[e] = 0, tt[e] = 4, tj[e] = -24, tjy[e] = 0, trf[e] = 121);
       break;
      case 2:
       0 == fvr && (pt_set1(t, o, 35), esp = 100);
       cmb = spdr = 0;
       break;
      case 3:
       pt_set3(t, o, u), esp = 12 < mes ? -20 : -200, 2200 < scr && (esp = -20)
      }
      0 == l && (tl[e] = 0, usi.push(e))
     }
     if (1 == tl[e] && 0 < ta[e]) {
      ctx.globalAlpha = ta[e];
      if (616 > ty[e]) switch (tt[e]) {
      case 0:
       spt(knmf[tf[e] | 0], t, o, u, 0);
       tf[e] += .5 * a;
       5 < tf[e] && (tf[e] = 0);
       break;
      case 1:
       spt(23 + (tf[e] | 0), t, o, 1.9 * u, 0);
       tf[e] += .2 * a;
       6 < tf[e] && (tf[e] = 0);
       break;
      case 2:
       spt(80, t, o, 1.9 * u, 0);
       break;
      case 3:
       spt(104 + (tf[e] | 0), t, o, 1.9 * u, 0);
       tf[e] += .3 * a;
       5 < tf[e] && (tf[e] = 0);
       break;
      case 4:
       tjy[e] += tj[e], tj[e] += 1.5, ty[e] += (220 - ty[e]) / 10, -10 < tjy[e] && 0 < tj[e] && (tjy[e] = 0, pt_set2(t, o, u), tl[e] = 0, usi.push(e), 0 == fvr && 40 > Math.abs(t - tx[0]) && 0 == mkt && (mkt = 16, mky = 0, mkj = -8, jsf = 45)), ctx.globalAlpha = .6, spt(53, t, o, 1.9 * u, 0), ctx.globalAlpha = 1, spt(trf[e] | 0, t, o + tjy[e], 1.9 * u, 0), trf[e] -= .5, 116 > trf[e] && (trf[e] = 121)
      }
      ctx.globalAlpha = 1
     }
    }
   }
   var c;
   0 <= msp ? (msp *= .95, .01 > Math.abs(msp) && (msp = 0), c = (msp + 1) / 80, 0 > c && (c = 0)) : 0 > msp && (msp++, c = 0);
   rmx -= c;
   0 <= esp ? (esp *= .95, .01 > Math.abs(esp) && (esp = 0), c = (esp + 1) / 80, 0 > c && (c = 0)) : 0 > esp && (esp++, c = 0);
   rex -= c;
   100 > rmx && (rmx += 100, rex += 100);
   mes = rex - rmx;
   28 < mes && (rex = rmx + 28)
  }
  uct += askb;
  e = slv;
  16 < e && (e = 16);
  0 != fvr && (e = 17);
  c = glv[e];
  r = gsp[e];
  1 < stti1 && 10 < e && 1 > mes && 0 == fvr && 0 == spdr && 0 == spdr1 && 0 == spdr2 && (fa_f["c" + fa_fi] = {
   x: Math.floor(200 * Math.random()) + 60,
   y: 355,
   fi: 5,
   pi: 0,
   ci: 0,
   l: 1
  }, fa_fi++, spdr2 = -1);
  0 < spdr1 && spdr1--;
  0 == bnsc ? 0 < stti1 && 9 < e && 4 > cmb && 16 > mes && 0 == fvr && 0 == bnst && 497 < 5e3 * Math.random() && 0 == spdr && 0 == spdr1 && 0 == spdr2 && (i = 50, 50 < 100 * Math.random() && (i = 220), fa_f["c" + fa_fi] = {
   x: i,
   y: 355,
   fi: 4,
   pi: 0,
   ci: 0,
   l: 1
  }, fa_fi++, spdr1 = 160) : (c = 10, e = 18);
  if (uct > c && (uct = 0, 0 < usi.length)) if (0 < spdr) iint(spdr + 26, 417, 2, 12), spdr = -2;
  else
  switch (c = Math.floor(260 * Math.random()) + 30, i = 0, e) {
  case 0:
  case 1:
   iint(c, 417, slv, r);
   break;
  case 2:
   iint(160, 417, 3, r);
   break;
  case 3:
   iint(c, 417, 0, r);
   break;
  case 4:
   50 < 100 * Math.random() && (i = 1);
   iint(c, 417, i, r);
   break;
  case 5:
  case 6:
  case 17:
   0 == mtitv ? (i = 3, c = 160, mtitv = Math.floor(5 * Math.random()) + 2) : 50 < 100 * Math.random() && (i = 1);
   mtitv--;
   iint(c, 417, i, r);
   break;
  case 7:
  case 8:
   8 < mes && 90 < 100 * Math.random() ? (e = r + 2, iint(50, 417, 0, e), iint(285, 417, 0, e)) : (0 == mtitv ? (i = 3, c = 160, mtitv = Math.floor(10 * Math.random()) + 2) : 50 < 100 * Math.random() && (i = 1), mtitv--, iint(c, 417, i, r));
   break;
  case 9:
   iint(c, 417, 1, r);
   break;
  case 18:
   10 < bnsc ? (iint(275 - 30 * (bnsc - 10), 417, 0, r), bnsc++, 18 < bnsc && (bnsc = 0)) : (iint(50 + 30 * bnsc, 417, 0, r), bnsc++, 8 < bnsc && (bnsc = 0));
   break;
  default:
   8 < mes && 90 < 100 * Math.random() ? (e = r + 2, iint(50, 417, 0, e), iint(285, 417, 0, e)) : (0 == mtitv ? (i = 3, c = 160, mtitv = Math.floor(10 * Math.random()) + 2) : 50 < 100 * Math.random() && (i = 1), mtitv--, iint(c, 417, i, r))
  }
  if (0 == ttlmd) {
   var h = 12 + 50 * (0 < fvr);
   scs(scr | 0, 1, h);
   spt2(78, 297, h);
   scr += .5 + .5 * (0 < fvr) + .5 * (0 < msp) + n;
   if (0 == fvr && (lscr++, lscr > gcl[slv])) switch (lscr = 0, slv++, slv) {
   case 5:
    mtitv = 0;
    break;
   case 9:
    uct = -10, 18 < mes && (rex = rmx + 18)
   }
   1 == hsmn && spt2(96, 245, h + 32);
   scr > bstscr && (fa_f["c" + fa_fi] = {
    x: 0,
    y: h - 12,
    fi: 3,
    pi: 0,
    ci: 0,
    l: 1
   }, fa_fi++, bstscr = 999999)
  } else
  switch (ttlct += askb, ttlct) {
  case 20:
   fa_f["c" + fa_fi] = {
    x: 0,
    y: 0,
    fi: 6,
    pi: 0,
    ci: 0,
    l: 1
   };
   fa_fi++;
   break;
  case 100:
   fa_f["c" + fa_fi] = {
    x: 0,
    y: 0,
    fi: 8,
    pi: 0,
    ci: 0,
    l: 1
   };
   fa_fi++;
   break;
  case 295:
   fa_f["c" + fa_fi] = {
    x: 0,
    y: 0,
    fi: 7,
    pi: 0,
    ci: 0,
    l: 1
   };
   fa_fi++;
   slv++;
   uct = 0;
   break;
  case 500:
   uct = 0;
   break;
  case 520:
   fa_f["c" + fa_fi] = {
    x: 0,
    y: 0,
    fi: 10,
    pi: 0,
    ci: 0,
    l: 1
   };
   fa_fi++;
   uct = -50;
   slv++;
   break;
  case 534:
   fa_f["c" + fa_fi] = {
    x: 0,
    y: 0,
    fi: 9,
    pi: 0,
    ci: 0,
    l: 1
   };
   fa_fi++;
   break;
  case 700:
   uct = -130;
   break;
  case 785:
   fa_f["c" + fa_fi] = {
    x: 0,
    y: 0,
    fi: 11,
    pi: 0,
    ci: 0,
    l: 1
   };
   fa_fi++;
   break;
  case 810:
   kmstt = 1;
   slv++;
   break;
  case 850:
   ttlmd = 0, pt_set1(290, 40, 32)
  }
  0 != fvr && (1 > fvra && (ctx.globalAlpha = fvra), 45 > fvr && (fvra += .025, 1 < fvra && (fvra = 1)), 261 < fvr && (fvra -= .025, 0 > fvra && (fvra = 0)), 1 == fvri ? spt2(91, 0, 0) : spt2(92, 0, 0), ctx.globalAlpha = 1, fvrc++, 3 < fvrc && (fvri = -fvri, fvrc = 0), msp = 5, fvr++, 300 < fvr && (cmb = fvr = 0, 9 == slv && 18 < mes && (rex = rmx + 18)));
  if (0 < fa_fi) {
   n = 0;
   for (f in fa_f) if (t = fa_f[f], 1 == t.l) {
    switch (t.fi) {
    case 0:
     r = [81, t.ci];
     for (e = 0; 2 > e; e++) u = 6 * t.pi + 3 * e, ctx.globalAlpha = fani[0][u + 2], spt2(r[e], fani[0][u] + t.x, fani[0][u + 1] + t.y);
     t.pi++;
     12 < t.pi && (t.l = 0, delete fa_f[f]);
     break;
    case 1:
     u = 3 * t.pi;
     ctx.globalAlpha = fani[1][u + 2];
     spt2(93, fani[1][u] + t.x, fani[1][u + 1]);
     t.pi++;
     44 < t.pi && (uct = 999, spdr = t.x, t.l = 0, delete fa_f[f]);
     break;
    case 2:
     u = 3 * t.pi;
     ctx.globalAlpha = fani[2][u + 2];
     spt2(90, fani[2][u], fani[2][u + 1]);
     t.pi++;
     40 < t.pi && 0 != fvr && (t.pi = 40);
     48 < t.pi && (t.l = 0, delete fa_f[f]);
     break;
    case 3:
     u = 3 * (t.pi | 0);
     ctx.globalAlpha = fani3[u + 2];
     spt2(79, fani3[u], h + 32);
     10 < t.pi && 20 > t.pi ? t.pi += .1 : t.pi++;
     30 < t.pi && (hsmn = 1, t.l = 0, delete fa_f[f]);
     break;
    case 4:
     u = 3 * t.pi;
     ctx.globalAlpha = fani[1][u + 2];
     spt2(94, fani[1][u] + t.x, fani[1][u + 1]);
     t.pi++;
     44 < t.pi && (bnsc = 100 > t.x ? 1 : 11, bnst = 1, t.l = 0, delete fa_f[f]);
     break;
    case 5:
     u = 3 * t.pi;
     ctx.globalAlpha = fani[1][u + 2];
     spt2(95, fani[1][u] + t.x, fani[1][u + 1]);
     t.pi++;
     44 < t.pi && (uct = 999, spdr = t.x, t.l = 0, delete fa_f[f]);
     break;
    case 6:
     for (e = 0; 3 > e; e++) u = 9 * t.pi + 3 * e, ctx.globalAlpha = fani4[u + 2], spt2(fanf4[e], fani4[u], fani4[u + 1]);
     t.pi++;
     63 < t.pi && (t.l = 0, delete fa_f[f]);
     break;
    case 7:
     u = 3 * t.pi;
     ctx.globalAlpha = fani5[u + 2];
     spt2(100, fani5[u], fani5[u + 1]);
     t.pi++;
     54 < t.pi && (spdr = t.x, t.l = 0, delete fa_f[f]);
     break;
    case 8:
     u = 3 * t.pi;
     ctx.globalAlpha = fani5[u + 2];
     spt2(99, fani5[u], fani5[u + 1]);
     t.pi++;
     54 < t.pi && (spdr = t.x, t.l = 0, delete fa_f[f]);
     break;
    case 9:
     for (e = 0; 3 > e; e++) u = 9 * t.pi + 3 * e, ctx.globalAlpha = fani6[u + 2], spt2(fanf6[e], fani6[u], fani6[u + 1]);
     t.pi++;
     63 < t.pi && (t.l = 0, delete fa_f[f]);
     break;
    case 10:
     u = 3 * t.pi;
     ctx.globalAlpha = fani5[u + 2];
     spt2(114, fani5[u], fani5[u + 1]);
     t.pi++;
     54 < t.pi && (spdr = t.x, t.l = 0, delete fa_f[f]);
     break;
    case 11:
     u = 5 * t.pi, ctx.globalAlpha = fani7[u + 4], spt4(124, fani7[u], fani7[u + 1], fani7[u + 2], fani7[u + 3]), t.pi++, 47 < t.pi && (t.l = 0, delete fa_f[f])
    }
    ctx.globalAlpha = 1;
    n++
   }
   0 == n && (fa_f = {}, fa_fi = 0)
  }
  gtm++; - 1 > mes && 196 > ty[1] ? dgt++ : dgt = 0; - 1 > mes && 80 < dgt && 0 == fvr && 300 < scr && 0 == ogm && (bcv2.drawImage(ctx.canvas, 0, 0, 320, 616, 0, 0, 320, 616), ogm = 1, scr |= 0, 999999 == bstscr && (e = new Date, e.setDate(e.getDate() + 730), document.cookie = "rvs_3d_run=" + scr + "endcksv; expires=" + e.toGMTString(), bstscr = scr))
 } else ogm++, 31 > ogm ? (ctx.drawImage(bcv2.canvas, 0, 0, 320, 616, 0, 0, 320, 616), f = ogm / 30, 1 < f && (f = 1), ctx.globalAlpha = f, ctx.fillStyle = "#000", ctx.fillRect(0, 0, 320, 616), ctx.globalAlpha = 1, spt2(126, bex[ef], bey[ef])) : 50 > ogm ? (ctx.globalAlpha = .5, f = 108 - gmovf, h = 100 + 2 * gmovf, gmovf += gmovc, gmovc += 3, ctx.drawImage(img7, 735, 0, 100, 100, f, f, h, h)) : (60 > ogm ? (f = (ogm - 50) / 30, 1 < f && (f = 1)) : (0 == gmovcl && (gmovcl = 1), ctx.drawImage(img2, 0, 0, 320, 616, 0, 0, 320, 616), scs2(99, String(scr).length, scr), bstscr == scr && spt2(150, 76, 103), 1 == gtips && spt2(152, 79, 309), 1 < gmsts && (spt2(152, 188, 320), 2 < gmsts && spt2(152, 276, 320)), f = 1 - (ogm - 60) / 30, 0 > f && (f = 0, s = 2, play68_submitScore(scr))), ctx.globalAlpha = f, ctx.fillStyle = "#FFF", ctx.fillRect(0, 0, 320, 616), ctx.globalAlpha = 1);
 750 > ttlct && spt2(153, 272, 5)
}
function iint(e, t, n, r) {
 var i = usi.shift();
 tx[i] = e;
 ty[i] = t;
 tt[i] = n;
 ts[i] = r;
 ta[i] = 1;
 tl[i] = 1
}
onload = function() {
 ldri = 0;
 ldlp = setInterval("lding();", 50);
 init();
 setTimeout(scrollTo, 400, 0, 1)
};