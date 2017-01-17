class PageUploader
    # A dummy pdf uploader to allow the pdf dialog to be tested in the
    # sandbox environment.

    @pagePath: 'new-page'

    constructor: (dialog) ->
        # Initialize the dialog to support image uploads

        @_dialog = dialog

        # Also hacking this together for a page create
        if !@_dialog.addEventListener
            return

        # Listen to key events from the dialog and assign handlers to each
        @_dialog.addEventListener 'pageuploader.create', (ev) =>
            @_onCreate(ev.detail().name)

    # Event handlers

    Create: (pageName) ->
        # Handle a text being selected by the user
        console.log pageName

        # Simulate uploading the specified file
        @_progress = 0
        upload = () =>
            @_progress += 5

            if @_progress <= 100
                @_uploadingTimeout = setTimeout(upload, 25)
            else
                @_dialog.populate(
                    PageUploader.pagePath
                    )

        @_uploadingTimeout = setTimeout(upload, 25)

    # Class methods

    @createPageUploader: (dialog) ->
        return new PageUploader(dialog)

window.PageUploader = PageUploader