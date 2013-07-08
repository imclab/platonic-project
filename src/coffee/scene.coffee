
window.log = (args...) => console?.log args...

class Scene

    constructor: ->

        @$window = $(window)

        # Viewport
        @$viewport = $ '.platonic-viewport'
        @$scene    = @$viewport.find '.scene'

        # Lighting
        @light       = new Photon.Light()
        @face_groups = []

        # Define facegroups
        $('.group:not(.mesh > .group):not([data-light="0"]), .mesh:not(.group > .mesh):not([data-light="0"])').each (index, element) =>
            face_group = new Photon.FaceGroup($(element)[0], $(element).find '.face', 0.8, 0.1, true)
            @face_groups.push face_group

        # Add camera
        @cam = new Camera @$viewport

        # Stats
        @stats = new Stats()
        @$viewport.append @stats.domElement

        # GUI
        @gui = new dat.GUI()
        cam_settings = @gui.addFolder 'Camera'
        cam_settings.add @cam, 'perspective', 0, 2000
        cam_settings.add(@cam, 'rotation_x' ).listen()
        cam_settings.add(@cam, 'rotation_y' ).listen()
        cam_settings.add(@cam, 'reset' )
        cam_settings.open()

        # Events
        @$window.resize => @on_resize()
        @$window.trigger 'resize'

        @loop()


    ###
    On window resize
    ###

    on_resize: ->

        @win_width  = @$window.width()
        @win_height = @$window.height()
            
        @$viewport.css height: @win_height + 'px'
        @$scene.css    height: @win_height + 'px'

        @cam.resize()

    ###
    Update on request animation frame
    ###

    update: ->

        @stats.begin()

        # Update cam
        @cam.update()
    
        # Update lighting
        if @face_groups.length > 0
            for face_group in @face_groups
                face_group.render @light, true

        @stats.end()


    ###
    Request animation frame tick
    ###

    loop: =>

        @update()
        requestAnimationFrame @loop


$ -> scene = new Scene()