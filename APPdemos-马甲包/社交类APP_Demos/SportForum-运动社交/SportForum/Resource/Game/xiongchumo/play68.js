var bSubmitScore = false;

function play68_init() {
	updateShare(0);
}

function goHome() {
	window.location.href = HOME_PATH;
}

function connectWebViewJavascriptBridge(callback)
{
  if (window.WebViewJavascriptBridge) {
    callback(WebViewJavascriptBridge)
  } else {
    document.addEventListener('WebViewJavascriptBridgeReady', function() {
      callback(WebViewJavascriptBridge)
    }, false)
  }
}

function play_result(score, bestScore) {
}

function play68_submitScore(score) {
	if (!bSubmitScore) 
	{
		bSubmitScore = true;

		connectWebViewJavascriptBridge(function(bridge) {
      		var data = {'CurrentScore' : score / 10, "BestScore" : -1}
     
      		bridge.send(data, function(responseData) {
      			console.log("Javascript got its response", responseData) 
      		})
   		})
	}
	//updateShareScore(score);
	//show_share();
}

function updateShare(bestScore) {
	imgUrl = 'http://web10.916d.com/games/xiongchumo/wenzhangku.png';
	//var domains = ['web10.916d.com','www.xinwenzhang.com'];
	//var domain = domains[new Date().getTime()%4];
	lineLink = 'http://web10.916d.com/games/xiongchumo/';
	descContent = "反向跑酷没玩过吧？快来一起跑！";
	updateShareScore(bestScore);
	appid = '';
}

function updateShareScore(bestScore) {
	if(bestScore > 0) {
		shareTitle = "我在《3D熊出没》被追了" + bestScore + "你，你能跑过我不？！";
	}
	else{
		shareTitle = "超华丽跑酷《3D熊出没》，你能跑多远？";
	}
}