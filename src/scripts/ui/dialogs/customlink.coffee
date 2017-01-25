class ContentTools.CustomLinkDialog extends ContentTools.DialogUI

	# A dialog to support inserting a custom link

	# Note: The dialog doesn't handle the searching of pages or documents it expects
	# this process to be handled by an external library. The external library
	# should be defined as an object against the ContentTools namespace like so:
	#
	# ContentTools.PDF_UPLOADER = externalPDFUploader
	# ContentTools.PAGE_UPLOADER = externalPageUploader
	# ContentTools.PAGE_SELECTOR = externalPageSelector
	#
	# The external library should provide an `init(dialog)` method. This method
	# recieves the dialog widget and can then set up all required event bindings
	# to support pdf uploads and page selection.

	constructor: (href='', target='') ->
		super('Create/Update Link')

		# If the dialog is populated, this is the href/target attribute
		@_fullURL = href
		@_target = target

		# Setup the different view elements
		@_mailTo = null
		@_pdfUploader = null

		# The initial state of the dialog
		@_state = 'empty'
		if (@_fullURL)
			@_state = 'populated'
		if (@_mailTo)
			@_state = 'populated-email'
		else if (@_pdf)
			@_state = 'populated-pdf'

	# Read-only properties

	anchorHref: () ->
		if @_basicAnchor
			@_target = @_basicAnchor.targetValue()
			return @_basicAnchor.anchorValue()
		if @_mailTo
			@_target = null
			return @_mailTo.anchorValue()
		if @_pdfUploader
			@_target = '_blank'
			return @_pdfUploader.anchorValue()

		return @_fullURL

	# Methods
	# Mail To
	addBasicAnchor: () ->
		# Add crop marks to the current image
		if @_basicAnchor
			return

		# Remove previous view
		ContentEdit.addCSSClass(@_domBasicAnchor, 'ct-control--active')
		@removeMailTo(true)
		@removePDFUploader(true)

		# Create active view
		@_basicAnchor = new BasicAnchorUI(@_fullURL, @_target)
		@_basicAnchor.mount(@_domView)
	removeBasicAnchor: () ->
		if !@_basicAnchor
			return

		@_basicAnchor.unmount()
		@_basicAnchor = null
		ContentEdit.removeCSSClass(@_domBasicAnchor, 'ct-control--active')
	# Mail To
	addMailTo: () ->
		# Add crop marks to the current image
		if @_mailTo
			return

		# Mark the crop control as active
		ContentEdit.addCSSClass(@_domMailTo, 'ct-control--active')
		@removeBasicAnchor()
		@removePDFUploader(true)

		# Create active view
		@_mailTo = new MailToUI(@_fullURL.replace('mailto:', ''))
		@_mailTo.mount(@_domView)
	removeMailTo: (change=false) ->
		if !@_mailTo
			return

		@_mailTo.unmount()
		@_mailTo = null
		ContentEdit.removeCSSClass(@_domMailTo, 'ct-control--active')
		if !change
			@addBasicAnchor()
	# PDF Uploader
	addPDFUploader: () ->
		if @_pdfUploader
			return
		
		# Remove previous view
		ContentEdit.addCSSClass(@_domPDF, 'ct-control--active')
		@removeBasicAnchor()
		@removeMailTo(true)
		#Create active view
		@_pdfUploader = new PDFUploaderUI()
		@_pdfUploader.mount(@_domView)
	removePDFUploader: (change=false) ->
		if !@_pdfUploader
			return

		@_pdfUploader.unmount()
		@_pdfUploader = null
		ContentEdit.removeCSSClass(@_domPDF, 'ct-control--active')
		if !change
			@addBasicAnchor()

	clear: () ->
		# Clear the attributes
		@_fullURL = null
		@_target = null

		@removeBasicAnchor()
		@removeMailTo()
		@removePDFUploader()

		@save(null, null)
		
	mount: () ->
		# Mount the widget
		super()

		# Update dialog class
		ContentEdit.addCSSClass(@_domElement, 'ct-custom-link-dialog')
		ContentEdit.addCSSClass(@_domElement, 'ct-custom-link-dialog--empty')

		# Update view class
		ContentEdit.addCSSClass(@_domView, 'ct-custom-link-dialog__view')

		# Add controls
		# THIS IS WHERE I LEFT OFF - I need to construct a type-group on the left, then certain controls should be put into `views` and the views should be controlled by the state and the type buttons can control the state
		# I also need to go into the sandbox and start creating a PDF_UPLOADER and a contactmanager
		# Image tools & progress bar
		domViewControls = @constructor.createDiv(
			['ct-control-group', 'ct-control-group--left'])
		@_domView.appendChild(domViewControls)

		# Basic Anchor
		@_domBasicAnchor = @constructor.createDiv([
			'ct-control',
			'ct-control--icon',
			'ct-control--text',
			'ct-control--anchor'
			])
		@_domBasicAnchor.setAttribute(
			'data-ct-tooltip',
			'manual'
			)
		@_domBasicAnchor.textContent = ContentEdit._('Web')
		domViewControls.appendChild(@_domBasicAnchor)
		# Mail To
		@_domMailTo = @constructor.createDiv([
			'ct-control',
			'ct-control--icon',
			'ct-control--text',
			'ct-control--mail'
			])
		@_domMailTo.setAttribute(
			'data-ct-tooltip',
			'mailto'
			)
		@_domMailTo.textContent = ContentEdit._('E-Mail')
		domViewControls.appendChild(@_domMailTo)
		# PDF
		@_domPDF = @constructor.createDiv([
			'ct-control',
			'ct-control--icon',
			'ct-control--text',
			'ct-control--pdf'
			])
		@_domPDF.setAttribute(
			'data-ct-tooltip',
			'pdf'
			)
		@_domPDF.textContent = ContentEdit._('PDF')
		domViewControls.appendChild(@_domPDF)

		if @_fullURL.indexOf('mailto:') == 0
			@addMailTo()
		else if @_fullURL.indexOf('.pdf') != -1
			@addPDFUploader
		else
			@addBasicAnchor()

		# Actions
		domActions = @constructor.createDiv(
			['ct-control-group', 'ct-control-group--right'])
		@_domControls.appendChild(domActions)
		# Clear
		if @_fullURL
			@_domClear = @constructor.createDiv([
				'ct-control',
				'ct-control--text',
				'ct-control--clear'
				])
			@_domClear.textContent = ContentEdit._('Remove')
			domActions.appendChild(@_domClear)
		# Cancel
		@_domCancel = @constructor.createDiv([
			'ct-control',
			'ct-control--text',
			'ct-control--cancel'
			])
		@_domCancel.textContent = ContentEdit._('Cancel')
		domActions.appendChild(@_domCancel)
		# Insert
		@_domInsert = @constructor.createDiv([
			'ct-control',
			'ct-control--text',
			'ct-control--insert'
			])
		if @_fullURL
			@_domInsert.textContent = ContentEdit._('Update')
		else
			@_domInsert.textContent = ContentEdit._('Insert')
		domActions.appendChild(@_domInsert)

		# Add interaction handlers
		@_addDOMEventListeners()

	save: (linkURL, target) ->
		# Return the props for the anchor to the custom-link tool
		linkURL = linkURL || @anchorHref()
		target = target || @_target
		if target
			@dispatchEvent(
				@createEvent(
					'save', { 'href': linkURL, 'target': target }
					)
				)
		else @dispatchEvent(
			@createEvent(
				'save', { 'href': linkURL }
				)
			)

	state: (state) ->
		# Set/get the state of the dialog (empty, uploading, populated)

		if state is undefined
			return @_state

		# Check that we need to change the current state of the dialog
		if @_state == state
			return

		# Modify the state
		prevState = @_state
		@_state = state

		# Update state modifier class for the dialog
		if not @isMounted()
			return

		ContentEdit.addCSSClass(@_domElement, "ct-custom-link-dialog--#{ @_state }")
		ContentEdit.removeCSSClass(
			@_domElement,
			"ct-custom-link-dialog--#{ prevState }"
			)

	unmount: () ->
		# Unmount the component from the DOM
		super()

		@removeBasicAnchor()
		@removeMailTo(true)
		@removePDFUploader(true)

		@_domMailTo = null
		@_domPDF = null

		@_domClear = null
		@_domCancel = null
		@_domInsert = null

	# Private methods

	_addDOMEventListeners: () ->
		# Add event listeners for the widget
		super()

		# Clear - removes anchor
		if @_domClear
			@_domClear.addEventListener 'click', (ev) =>
				@clear()

		# Cancel - restores previous element state
		@_domCancel.addEventListener 'click', (ev) =>
			@dispatchEvent(@createEvent('cancel'))

		# Web link
		@_domBasicAnchor.addEventListener 'click', (ev) =>
			@state('web')
			@addBasicAnchor()
		# MailTo link
		@_domMailTo.addEventListener 'click', (ev) =>
			@state('mailTo')
			@addMailTo()
		# PDF link
		@_domPDF.addEventListener 'click', (ev) =>
			@state('pdf')
			@addPDFUploader()
		
		# Creates/Updates Anchor
		@_domInsert.addEventListener 'click', (ev) =>
			@save()
		
		@_domView.addEventListener 'keypress', (ev) =>
			if ev.keyCode is 13
				@save()
				ev.preventDefault()

class BasicAnchorUI extends ContentTools.AnchoredComponentUI

	constructor: (url='',target='') ->
		super()

		@_url = url
		@_target = target

		if ContentTools.PAGE_SELECTOR
			ContentTools.PAGE_SELECTOR(this)

	mount: (domParent, before=null) ->
		@_domElement = @constructor.createDiv([
			'ct-section-group',
			'ct-section--other'
		])

		# URL input
		@_domURL = @constructor.createDiv([
			'ct-section',
			'ct-section--applied',
			'ct-section--contains-input'
		])
		@_domElement.appendChild(@_domURL)
		
		domInputLabel = @constructor.createDiv(['ct-section__label'])
		domInputLabel.textContent = ContentEdit._('URL')
		@_domURL.appendChild(domInputLabel)
		
		@_domInput = document.createElement('input')
		@_domInput.setAttribute('class', 'ct-section__input')
		@_domInput.setAttribute('name', 'url')
		@_domInput.setAttribute('type', 'url')
		@_domInput.setAttribute('autofocus', 'autofocus')
		@_domInput.setAttribute('value', @_url)
		@_domURL.appendChild(@_domInput)

		# Target Input
		# Removing for now, will manually set based on absolute or relative path
		#targetCSSClasses = ['ct-section']
		#if @_target
			#targetCSSClasses.push('ct-section--applied')
		#@_domTargetSection = @constructor.createDiv(targetCSSClasses)
		#@_domElement.appendChild(@_domTargetSection)

		#domTargetLabel = @constructor.createDiv(['ct-section__label'])
		#domTargetLabel.textContent = ContentEdit._('New Window')
		#@_domTargetSection.appendChild(domTargetLabel)

		#@_domTargetSwitch = @constructor.createDiv(['ct-section__switch'])
		#@_domTargetSection.appendChild(@_domTargetSwitch)

		if ContentTools.PAGE_SELECTOR
			@_domOutput = @constructor.createDiv(['ct-output'])
			@_domElement.appendChild(@_domOutput)
			@dispatchEvent(@createEvent('pageselector.mount', { input : @_domInput, output : @_domOutput, current : @_url }))

		super(domParent, before)

	unmount: () ->

		# Unselect any content
		if @isMounted()
			@_domInput.blur()

		super()

		@_domElement = null
		@_domURL = null
		@_domInput = null
		if ContentTools.PAGE_SELECTOR
			@_domOutput = null
		#@_domTargetSection = null
		#@_domTargetSwitch = null

	populate: (v) ->

		@_domInput.value = v

	_addDOMEventListeners: () ->
		super()

		if ContentTools.PAGE_SELECTOR
			@_domInput.addEventListener 'keyup', (ev) =>
				this.dispatchEvent(this.createEvent('pageselector.filter'), { rawInput: ev.target.value })
			@_domOutput.addEventListener 'click', (ev) =>
				while ev.target != ev.currentTarget
					if ev.target.getAttribute('value')
						this.populate(ev.target.getAttribute('value'))
						break
		
		#@_domTargetSection.addEventListener 'click', (ev) =>
			#this._domTargetSection.classList.toggle('ct-section--applied')

	anchorValue: () ->
		if @_domInput.value
			return @_domInput.value
		return ''
	targetValue: () ->
		#targetCSSClass = @_domTargetSection.getAttribute('class')
		#return (targetCSSClass.indexOf('ct-section--applied') > -1 ? '_blank' : null)
		if @_domInput.value.indexOf('//') is -1
			return null
		return '_blank'

class MailToUI extends ContentTools.AnchoredComponentUI

	constructor: (email='') ->
		super()

		@_userEmail = email

	mount: (domParent, before=null) ->
		@_domElement = @constructor.createDiv([
			'ct-section',
			'ct-section--mailto',
			'ct-section--applied',
			'ct-section--contains-input'
		])
		
		domEmailLabel = @constructor.createDiv(['ct-section__label'])
		domEmailLabel.textContent = ContentEdit._('Email Address')
		@_domElement.appendChild(domEmailLabel)
		
		@_domInput = document.createElement('input')
		@_domInput.setAttribute('class', 'ct-section__input')
		@_domInput.setAttribute('name', 'email')
		@_domInput.setAttribute('type', 'email')
		@_domInput.setAttribute('autofocus', 'autofocus')
		@_domInput.setAttribute('value', @_userEmail)
		@_domElement.appendChild(@_domInput)
		
		@dispatchEvent(@createEvent('contactmanager.mount'))

		super(domParent, before)

	unmount: () ->

		# Unselect any content
		if @isMounted()
			@_domInput.blur()

		super()

		@_domElement = null
		@_domInput = null

	_addDOMEventListeners: () ->
		super()

		@_domInput.addEventListener 'keydown', (ev) =>
			if ev.button is 13
				@dispatchEvent(@createEvent('save'))

	anchorValue: () ->
		if @_domInput.value
			return 'mailto:' + @_domInput.value

		return ''

class PDFUploaderUI extends ContentTools.AnchoredComponentUI

	constructor: () ->
		super()

		@_file = null
		# The upload progress of the dialog (0-100)
		@_progress = 0

		@_state = null

		# If an image uploader factory is defined create a new uploader for the
		# dialog.
		if ContentTools.PDF_UPLOADER
			ContentTools.PDF_UPLOADER(this)

	mount: (domParent, before=null) ->
		@_domElement = @constructor.createDiv([
			'ct-section',
			'ct-section--pdf',
			'ct-section--applied'
		])
		domActions = @constructor.createDiv([
			'ct-control-group',
			'ct-control-group--wide'
		])
		@_domElement.appendChild(domActions)
		# Upload button
		@_domUpload = @constructor.createDiv([
			'ct-control',
			'ct-control--text',
			'ct-control--upload'
			])
		@_domUpload.textContent = ContentEdit._('Upload')
		domActions.appendChild(@_domUpload)

		# File input for upload
		@_domInput = document.createElement('input')
		@_domInput.setAttribute('class', 'ct-custom-link-dialog__file-upload')
		@_domInput.setAttribute('name', 'file')
		@_domInput.setAttribute('type', 'file')
		@_domInput.setAttribute('accept', 'application/pdf')
		@_domUpload.appendChild(@_domInput)

		# Progress bar
		domProgressBar = @constructor.createDiv(['ct-progress-bar'])
		domActions.appendChild(domProgressBar)

		@_domProgress = @constructor.createDiv(['ct-progress-bar__progress'])
		domProgressBar.appendChild(@_domProgress)

		@dispatchEvent(@createEvent('pdfuploader.mount'))

		super(domParent, before)

	unmount: () ->
	
		# Unselect any content
		if @isMounted()
			@_domInput.blur()
			
		super()
		
		@_domElement = null
		@_domProgress = null
		@_domInput = null
		@_domUpload = null

		@dispatchEvent(@createEvent('pdfuploader.unmount'))

	state: (state) ->
		# Set/get the state of the dialog (empty, uploading, populated)

		if state is undefined
			return @_state

		# Check that we need to change the current state of the dialog
		if @_state == state
			return

		# Modify the state
		prevState = @_state
		@_state = state

		# Update state modifier class for the dialog
		if not @isMounted()
			return

		ContentEdit.addCSSClass(@_domElement, "ct-section--#{ @_state }")
		ContentEdit.removeCSSClass(
			@_domElement,
			"ct-section--#{ prevState }"
			)

	progress: (progress) ->
		# Get/Set upload progress
		if progress is undefined
			return @_progress

		@_progress = progress

		# Update progress bar width
		if not @isMounted()
			return

		@_domProgress.style.width = "#{ @_progress }%"

		if @_progress == 100
			@_domProgress.style.backgroundColor = '#27ae60';
		else if @_domProgress.style.backgroundColor != ''
			@_domProgress.style.backgroundColor = ''

	
	populate: (uploadedPath) ->
		# Populate the dialog 
		@_uploadedPath = uploadedPath

	_addDOMEventListeners: () ->
		super()

		# File ready for upload
		@_domInput.addEventListener 'change', (ev) =>
			# Get the file uploaded
			file = ev.target.files[0]

			# Clear the file inputs value so that the same file can be uploaded
			# again if the user cancels the upload or clears it and starts then
			# changes their mind.
			ev.target.value = ''
			if ev.target.value
				# Hack for clearing the file field value in IE
				ev.target.type = 'text'
				ev.target.type = 'file'

			@dispatchEvent(
				@createEvent('pdfuploader.fileready', {file: file})
				)

	anchorValue: () ->
		if @_uploadedPath
			return @_uploadedPath

		return ''