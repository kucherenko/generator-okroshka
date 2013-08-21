/*global describe, beforeEach, it*/
'use strict';

var path = require('path');
var helpers = require('yeoman-generator').test;


describe('okroshka generator', function () {
    beforeEach(function (done) {
        helpers.testDirectory(path.join(__dirname, 'temp'), function (err) {
            if (err) {
                return done(err);
            }

            this.app = helpers.createGenerator('okroshka:app', [
                '../../app'
            ]);
            done();
        }.bind(this));
    });

    it('creates expected files', function (done) {
        var expected = [
            // add files and folders you expect to exist here.
            '.jshintrc',
            '.bowerrc',
            '.editorconfig',
            'Gruntfile.coffee',
            // folders
            'src',
            'test',
            'lib',
            'test/unit',
            'assets',
            'assets/templates',
            'assets/stylesheets',
            'assets/images',

        ];

        helpers.mockPrompt(this.app, {});

        this.app.options['skip-install'] = true;
        this.app.run({}, function () {
            helpers.assertFiles(expected);
            done();
        });
    });

    it('creates folders', function () {

    })
});
