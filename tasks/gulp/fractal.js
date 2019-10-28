const config = require('./../config');

/*
* Require the path module
*/
const path = require('path');

/*
 * Require the Fractal module
 */
const fractal = module.exports = require('@frctl/fractal').create();

/*
 * Give your project a title.
 */
fractal.set('project.title', config.currentWebsite);
/*
 * Tell Fractal where to look for components.
 */
fractal.components.set('path', path.join(__dirname, '../../fractal/components'));
fractal.components.set('default.preview', '@preview');
fractal.components.set('default.context', {
  imgDir: `/themes/${config.currentWebsite}/Images`,
  site: config.currentWebsite,
});

/*
 * Tell Fractal where to look for documentation pages.
 */
fractal.docs.set('path', path.join(__dirname, '../../fractal/docs'));

/*
 * Tell the Fractal web preview plugin where to look for static assets.
 */
fractal.web.set('static.path', path.join(__dirname, `../../${config.directories.buildDirectory}/Website`));

const logger = fractal.cli.console;

module.exports = function (gulp) {
  return function () {
    const server = fractal.web.server({
      sync: true,
    });

    server.on('error', err => logger.error(err.message));

    return server.start().then(() => {
      logger.success(`Fractal server is now running at ${server.url} for project ${config.currentWebsite}`);
    });
  };
};
