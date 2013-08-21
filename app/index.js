'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var Handlebars = require('handlebars');


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
    this.mkdir('src');
    this.mkdir('lib');
    this.mkdir('assets');
    this.mkdir('assets/templates');
    this.mkdir('assets/stylesheets');
    this.mkdir('assets/images');
    this.mkdir('test');
    this.mkdir('test/unit');

    var settings = {
            isAMD: this.isAMD,
            isHandlebars: this.isHandlebars,
            isI18n: this.isI18n
        },
        gruntfile = this.readFileAsString(path.join(this.sourceRoot(), 'Gruntfile.hbs')),
        packageJson = this.readFileAsString(path.join(this.sourceRoot(), 'package.hbs')),
        bowerJson = this.readFileAsString(path.join(this.sourceRoot(), 'bower.hbs'));

    gruntfile = Handlebars.compile(gruntfile);
    gruntfile = gruntfile(settings);

    packageJson = Handlebars.compile(packageJson);
    packageJson = packageJson(settings);

    bowerJson = Handlebars.compile(bowerJson);
    bowerJson = bowerJson(settings);

    this.write('Gruntfile.coffee', gruntfile);
    this.write('package.json', packageJson);
    this.write('bower.json', bowerJson);

    this.copy('_bowerrc', '.bowerrc');
};

OkroshkaGenerator.prototype.projectfiles = function projectfiles() {
    this.copy('editorconfig', '.editorconfig');
    this.copy('jshintrc', '.jshintrc');
};
