'use strict';
var util = require('util'),
    path = require('path'),
    yeoman = require('yeoman-generator'),
    wrench = require('wrench');


var OkroshkaGenerator = module.exports = function OkroshkaGenerator(args, options, config) {
    yeoman.generators.Base.apply(this, arguments);

    this.on('end', function () {
        this.installDependencies({ skipInstall: options['skip-install'] });
    });

    this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(OkroshkaGenerator, yeoman.generators.Base);

OkroshkaGenerator.prototype.askFor = function askFor() {
    var cb = this.async();

    // have Yeoman greet the user.
    console.log(this.yeoman);

    var prompts = [
        {
            type: 'confirm',
            name: 'isAMD',
            message: 'Would you like to use AMD?',
            default: true
        },
        {
            type: 'confirm',
            name: 'isHandlebars',
            message: 'Would you like to use handlebars template engine?',
            default: true
        },
        {
            type: 'confirm',
            name: 'isI18n',
            message: 'Would you like to use i18n?',
            default: true
        }
    ];

    this.prompt(prompts, function (props) {
        this.isAMD = props.isAMD;
        this.isHandlebars = props.isHandlebars;
        this.isI18n = props.isI18n;
        cb();
    }.bind(this));
};

OkroshkaGenerator.prototype.app = function app() {
    wrench.copyDirSyncRecursive(this.sourceRoot() + '/app/', 'app');
    this.mkdir('test');
    this.mkdir('test/unit');

    this.template('Gruntfile.coffee');
    this.template('package.json');
    this.template('bower.json');

    this.copy('_bowerrc', '.bowerrc');
    this.copy('index.html', 'app/index.html');
    this.copy('404.html', 'app/404.html');
};

OkroshkaGenerator.prototype.projectfiles = function projectfiles() {
    this.copy('editorconfig', '.editorconfig');
    this.copy('jshintrc', '.jshintrc');
};
