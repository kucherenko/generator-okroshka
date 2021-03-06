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
            // files
            '.jshintrc',
            '.gitignore',
            '.bowerrc',
            '.editorconfig',
            'Gruntfile.coffee',
            'app/index.html',
            'app/404.html',

            // folders
            'app',
            'app/scripts',
            'app/scripts/models',
            'app/scripts/collections',
            'app/scripts/helpers',
            'app/scripts/routes',
            'app/scripts/views',
            'app/scripts/templates',
            'app/styles',
            'app/images',
            'test',
            'test/specs',
            'test/features',
            'test/features/step_definitions',
            'test/features/support'
        ];

        helpers.mockPrompt(this.app, {});

        this.app.options['skip-install'] = true;
        this.app.run({}, function () {
            helpers.assertFiles(expected);
            done();
        });
    });
});
