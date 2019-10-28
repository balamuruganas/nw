const gulp = require('gulp')
const plugins = require('gulp-load-plugins')()

const config = require('./tasks/config')

/**
 * @desc Helper function to retrieve a
 * gulp task from the gulp task Directory
 *
 * @param  {string} task
 * @returns function The corresponding gulp task
 */
function getTask(task) {
  return require(`./tasks/gulp/${task}`)(gulp, plugins)
}

/**
 * Here we define all available gulp tasks
 */
gulp.task('scripts', getTask('scripts'))
gulp.task('eslint', getTask('eslint'))
gulp.task('styles', getTask('styles'))
gulp.task('styles-prefix', getTask('styles.prefix'))
gulp.task('fonts', getTask('fonts'))
gulp.task('images', getTask('images'))
gulp.task('fractal', getTask('fractal'))
gulp.task('icons', getTask('icons'))
gulp.task('a11y', getTask('a11y'))
gulp.task('refapp-images', getTask('refapp-images'))

/**
 * Build tasks
 */
gulp.task('build', ['scripts', 'styles', 'fonts', 'images', 'refapp-images'])

/** Develop tasks */

gulp.task('watch', ['build'], () => {
  gulp.watch([`${config.directories.foundationDirectory}**/*.js`, `${config.directories.featureDirectory}**/*.js`, `${config.directories.projectDirectory}**/*.js`], { interval: 750 }, ['eslint', 'scripts'])
  gulp.watch([`${config.directories.foundationDirectory}**/*.vue`, `${config.directories.featureDirectory}**/*.vue`, `${config.directories.projectDirectory}**/*.vue`], { interval: 750 }, ['eslint', 'scripts'])
  gulp.watch([`${config.directories.featureDirectory}**/*.scss`, `${config.directories.projectDirectory}**/*.scss`], { interval: 750 }, ['styles'])
})

gulp.task('develop', ['watch', 'fractal'])
