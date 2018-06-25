const webpack = require('webpack'),
      webpackBundleAnalyzer = require('webpack-bundle-analyzer').BundleAnalyzerPlugin,
      gutil = require("gulp-util");

var productionPlugins = gutil.env.production !== undefined && gutil.env.production ? [
  new webpack.optimize.UglifyJsPlugin({
      compress: {
          warnings: false
      },
      comments: false,
      sourceMap: true
  }),
	new webpack.ProgressPlugin(function(percentage, message) {
		const percent = Math.round(percentage * 100);
		process.stderr.clearLine();
		process.stderr.cursorTo(0);
		process.stderr.write(percent + "% " + message);
	})
] : (gutil.env.analyzer !== undefined && gutil.env.analyzer ? [
  new webpackBundleAnalyzer()
] : []);
var loaders = [
            {
              test: /\.(png|jpe?g|gif|svg|woff|woff2|ttf|eot|ico)$/,
              loader: 'file?name=[path]/[name].[ext]'
            },
            {
              test: /\.css$/,
              use: [
                {
                  loader: 'style-loader',
                  options: {
                    minimize: true
                  }
                },
                {
                  loader: 'css-loader',
                  options: {
                    minimize: true
                  }
                }
              ]
            },
            {
              test: /\.scss$/,
              exclude: /node_modules/,
              // loaders: ['style-loader','css-loader','sass-loader?modules=true']
              use: [
                {
                  loader: 'ruby-sass-loader',
                  options: {
                    modules: true,
                    compass: true,
                    localIdentName: '___[hash:base64:5]',
                    minimize: true
                  }
                },
                {loader: 'style-loader'},
                {loader: 'css-loader'},
              ]
            },
            {
              query: {
                  presets: ['es2015']
              },
              test: /\.cjsx$/, loader: "coffee-jsx-loader",// all you have to do is just load this loader
            }
          ];
var environment = {
  plugins: productionPlugins,
  loaders: loaders,
}
exports.environment = environment;
