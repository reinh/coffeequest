module.exports = (grunt) ->
  pkg = grunt.file.readJSON('package.json')

  grunt.initConfig
    pkg: pkg

    watch:
      coffee:
        files: ['src/coffee/*']
        tasks: 'coffee'
      stylus:
        files: ['src/stylus/*']
        tasks: 'stylus'

    coffee:
      compile:
        files: [
          expand: true
          dest: '_site/js/'
          cwd: 'src/coffee'
          src: ['**/*.coffee', '**/*.litcoffee']
          ext: '.js'
        ]

    coffeelint:
      source: '_site/src/coffee/**/*.coffee'
      grunt: 'Gruntfile.coffee'

    stylus:
      compile:
        files:
          '_site/css/app.css': 'src/stylus/app.styl'

    copy:
      main:
        files: [
          { src: 'index.html', dest: '_site/index.html' }
        ]

    githubPages:
      target:
        options:
          commitMessage: 'Publishing!'
        src: '_site'

  # Dependencies
  for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
    grunt.loadNpmTasks name

  grunt.registerTask 'publish',
                     'Publish the site to GitHub Pages',
                     ['coffee', 'stylus', 'copy', 'githubPages:target']
