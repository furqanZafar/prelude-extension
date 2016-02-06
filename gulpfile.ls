require! \browserify
require! \gulp
require! \gulp-if
require! \gulp-livescript
require! \gulp-mocha
{instrument, hook-require, write-reports} = (require \gulp-livescript-istanbul)!
require! \gulp-streamify
require! \gulp-uglify
require! \gulp-util
source = require \vinyl-source-stream

gulp.task \build, ->
    gulp.src <[./index.ls]>
    .pipe gulp-livescript!
    .pipe gulp.dest \./

gulp.task \watch, ->
    gulp.watch <[./index.ls]>, <[build]>

# create-standalone-build :: Boolean -> {file :: String, directory :: String} -> Stream
create-standalone-build = (minify, {file, directory}) ->
    browserify standalone: \prelude-extension, debug: false
        .add <[./index.js]>
        .exclude \prelude-ls
        .bundle!
        .on \error, -> gulp-util.log arguments
        .pipe source file
        .pipe gulp-if minify, (gulp-streamify gulp-uglify!)
        .pipe gulp.dest directory

gulp.task \dist, <[build]>, ->
    create-standalone-build false, {file: \index.js, directory: \./dist} .on \finish, ->
        create-standalone-build true, {file: \index.min.js, directory: \./dist}

gulp.task \coverage, ->
    gulp.src <[./index.ls]>
    .pipe instrument!
    .pipe hook-require!
    .on \finish, ->
        gulp.src <[./test/index.ls]>
        .pipe gulp-mocha!
        .pipe write-reports!
        .on \finish, -> process.exit!

gulp.task \default, <[build watch]>