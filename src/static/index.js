//import registerServiceWorker from './registerServiceWorker';
//require('./registerServiceWorker');

// pull in styl
require( './styles/main.styl' );

// inject bundled Elm app into div#main
var Elm = require( '../elm/Game' );
Elm.Game.embed( document.getElementById( 'main' ) );
