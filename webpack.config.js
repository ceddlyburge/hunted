var path              = require( 'path' );
var webpack           = require( 'webpack' );
var merge             = require( 'webpack-merge' );
var HtmlWebpackPlugin = require( 'html-webpack-plugin' );
var autoprefixer      = require( 'autoprefixer' );
var ExtractTextPlugin = require( 'extract-text-webpack-plugin' );
var CopyWebpackPlugin = require( 'copy-webpack-plugin' );
var entryPath         = path.join( __dirname, 'src/static/index.js' );
var outputPath        = path.join( __dirname, 'dist' );
var SWPrecacheWebpackPlugin = require('sw-precache-webpack-plugin');
const WebpackPwaManifest = require('webpack-pwa-manifest');

console.log( 'WEBPACK GO!');

const PUBLIC_PATH = '';  // webpack needs the trailing slash for output.publicPath

// determine build env
var TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development';
var outputFilename = TARGET_ENV === 'production' ? '[name]-[hash].js' : '[name].js'

// common webpack config
var commonConfig = {

  output: {
    path:       outputPath,
    filename: `/static/js/${outputFilename}`
    //publicPath: PUBLIC_PATH
  },

  resolve: {
    extensions: ['', '.js', '.elm']
  },

  module: {
    noParse: /\.elm$/,
    loaders: [
      {
        test: /\.(eot|ttf|woff|woff2|svg)$/,
        loader: 'file-loader'
      }
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/static/index.html',
      inject:   'body',
      filename: 'index.html'
    })
    , new SWPrecacheWebpackPlugin(
      {
        cacheId: 'ceddlyburge/hunted',
        dontCacheBustUrlsMatching: /\.\w{8}\./,
        filename: 'service-worker.js',
        minify: false,
        navigateFallback: PUBLIC_PATH + 'index.html',
        staticFileGlobsIgnorePatterns: [/\.map$/, /manifest\.json$/]
      }
    )
    , new WebpackPwaManifest({
      name: 'Hunted - a simple game',
      short_name: 'Hunted',
      description: 'A game developed in Elm, mainly as a means to learning new things',
      background_color: '#ffffff',
      theme_color: '#000000',
      start_url: '/',
      icons: [
        {
          src: path.resolve('src/static/img/android-icon.png'),
          sizes: [192],
          destination: path.join('static', 'img')
        }
      ]
    })
  ],

  postcss: [ autoprefixer( { browsers: ['last 2 versions'] } ) ],

}

// additional webpack settings for local env (when invoked by 'npm start')
if ( TARGET_ENV === 'development' ) {
  console.log( 'Serving locally...');

  module.exports = merge( commonConfig, {

    entry: [
      'webpack-dev-server/client?http://localhost:8080',
      entryPath
    ],

    devServer: {
      // serve index.html in place of 404 responses
      historyApiFallback: true,
      contentBase: './src',
    },

    module: {
      loaders: [
        {
          test:    /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader:  'elm-hot!elm-webpack?verbose=true&warn=true&debug=true'
        },
        {
          test: /\.(css|styl)$/,
          loaders: [
            'style-loader',
            'css-loader',
            'postcss-loader',
            'stylus-loader'
          ]
        }
      ]
    }

  });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if ( TARGET_ENV === 'production' ) {
  console.log( 'Building for prod...');

  module.exports = merge( commonConfig, {

    entry: entryPath,

    module: {
      loaders: [
        {
          test:    /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader:  'elm-webpack'
        },
        {
          test: /\.(css|styl)$/,
          loader: ExtractTextPlugin.extract( 'style-loader', [
            'css-loader',
            'postcss-loader',
            'stylus-loader'
          ])
        }
      ]
    },

    plugins: [
      new CopyWebpackPlugin([
        {
          from: 'src/static/img/',
          to:   'static/img/'
        },
      ]),

      new webpack.optimize.OccurenceOrderPlugin(),

      // extract CSS into a separate file
      new ExtractTextPlugin( 'static/css/[name]-[hash].css', { allChunks: true } ),

      // minify & mangle JS/CSS
      new webpack.optimize.UglifyJsPlugin({
          minimize:   true,
          compressor: { warnings: false }
          // mangle:  true
      })
    ]

  });
}
