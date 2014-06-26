module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        concat: {
            options: {
                separator: "\n\n#### Another file ####\n\n"
            },
            dist: {
                src: ['src/game.js.coffee', 'src/piece.js.coffee', 'src/chess.js.coffee'],
                dest: 'build/concat.<%= pkg.name %>.js.coffee'
            }
        },
        coffee: {
            compile: {
                files: {
                    'build/<%= pkg.name %>.js':  '<%= concat.dist.dest %>'
                }
            }
        },
        uglify: {
            options: {
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            },
            build: {
                src: 'build/<%= pkg.name %>.js',
                dest: 'public/assets/javascripts/<%= pkg.name %>.min.js'
            }
        },
        watch: {
            files: ['<%= concat.dist.src %>'],
            tasks: ['concat', 'coffee','uglify']
        }

    });

    // Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-watch');

    // Default task(s).
    grunt.registerTask('default', ['concat', 'coffee', 'uglify']);

};