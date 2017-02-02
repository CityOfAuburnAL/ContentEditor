class PDFUploader
    # A dummy pdf uploader to allow the pdf dialog to be tested in the
    # sandbox environment.

    @pdfPath: 'doc.pdf'

    constructor: (dialog) ->
        # Initialize the dialog to support image uploads

        @_dialog = dialog

        # Listen to key events from the dialog and assign handlers to each
        # Not Implemented
        @_dialog.addEventListener 'cancel', () =>
            @_onCancel()
        # Not Implemented
        @_dialog.addEventListener 'pdfuploader.cancelupload', () =>
            @_onCancelUpload()
        # Not Implemented
        @_dialog.addEventListener 'pdfuploader.clear', () =>
            @_onClear()

        @_dialog.addEventListener 'pdfuploader.fileready', (ev) =>
            @_onFileReady(ev.detail().file)

        @_dialog.addEventListener 'pdfuploader.mount', () =>
            @_onMount()
        # Not Implemented
        @_dialog.addEventListener 'pdfuploader.save', () =>
            @_onSave()

        @_dialog.addEventListener 'pdfuploader.unmount', () =>
            @_onUnmount()

    # Event handlers

    _onCancel: () ->
        # Handle the user cancelling the dialog

    _onCancelUpload: () ->
        # Handle an upload being cancelled

        # Stop the upload
        clearTimeout(@_uploadingTimeout)

        # Set the dialog to empty
        @_dialog.state('empty')

    _onClear: () ->
        # Handle the current image being cleared
        @_dialog.clear()

    _onFileReady: (file) ->
        # Handle a file being selected by the user
        console.log file

        # Set the dialog state to uploading
        @_dialog.progress(0)
        @_dialog.state('uploading')

        # Simulate uploading the specified file
        upload = () =>
            progress = @_dialog.progress()
            progress += 1

            if progress <= 100
                @_dialog.progress(progress)
                @_uploadingTimeout = setTimeout(upload, 25)
            else
                @_dialog.populate(
                    PDFUploader.pdfPath
                    )

        @_uploadingTimeout = setTimeout(upload, 25)

    _onMount: () ->
        # Handle the dialog being mounted on the UI

    _onSave: () ->
        # Handle the user saving the image

        # Simulate processing the image
        @_dialog.busy(true)
        clearBusy = () =>
            @_dialog.busy(false)
            @_dialog.save(
                PDFUploader.pdfPath
                {alt: 'Example of bad variable names'}
                )

        setTimeout(clearBusy, 1500)

    _onUnmount: () ->
        # Handle the dialog being unmounted from the UI

    # Class methods

    @createPDFUploader: (dialog) ->
        return new PDFUploader(dialog)

window.PDFUploader = PDFUploader