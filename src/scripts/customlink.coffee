class CustomLinkTool extends ContentTools.Tools.Link

	#Register
	ContentTools.ToolShelf.stow(@, 'custom-link');

	#Config
	@label = 'Custom Link'
	@icon = 'link'
	@tagName = 'a'

	@apply: (element, selection, callback) ->
		# Dispatch `apply` event
		toolDetail = {
            'tool': this,
            'element': element,
            'selection': selection
            }
		if not @dispatchEditorEvent('tool-apply', toolDetail)
            return

		# Get app to attach dialog to
		app = ContentTools.EditorApp.get()

		# Prepare text elements for adding a link
		if element.type() is 'Image'
			# Images
			rect = element.domElement().getBoundingClientRect()

		else
			# If the selection is collapsed then we need to select the entire
			# entire link.
			if selection.isCollapsed()

				# Find the bounds of the link
				characters = element.content.characters
				starts = selection.get(0)[0]
				ends = starts

				while starts > 0 and characters[starts - 1].hasTags('a')
					starts -= 1

				while ends < characters.length and characters[ends].hasTags('a')
					ends += 1

				# Select the link in full
				selection = new ContentSelect.Range(starts, ends)
				selection.select(element.domElement())
			else
				# Custom bit here to deselect whitespace after a word (from double-clicking)
				[from, to] = selection.get()
				if element.content.characters[to - 1].isWhitespace()
						selection = new ContentSelect.Range(from, to - 1)
						selection.select(element.domElement())

			# Text elements
			element.storeState()

			# Add a fake selection wrapper to the selected text so that it
			# appears to be selected when the focus is lost by the element.
			selectTag = new HTMLString.Tag('span', {'class': 'ct--puesdo-select'})
			[from, to] = selection.get()
			element.content = element.content.format(from, to, selectTag)
			element.updateInnerHTML()

			# Measure a rectangle of the content selected so we can position the
			# dialog centrally.
			domElement = element.domElement()
			measureSpan = domElement.getElementsByClassName('ct--puesdo-select')
			rect = measureSpan[0].getBoundingClientRect()

		# Modal
		modal = new ContentTools.ModalUI()

        # Dialog
		dialog = new ContentTools.CustomLinkDialog(
            @getAttr('href', element, selection),
            @getAttr('target', element, selection)
            )

        # Support cancelling the dialog
		dialog.addEventListener 'cancel', () =>
			dialog.unmount()
			dialog.hide()
			modal.hide()

			if element.content
				# Remove the fake selection from the element
				element.content = element.content.unformat(from, to, selectTag)
				element.updateInnerHTML()
				
				# Restore the selection
				element.restoreState()
				
			callback(false)

		# Support saving the dialog
		dialog.addEventListener 'save', (ev) ->
			detail = ev.detail()
			
			# Add the link
			if element.type() is 'Image'
			
				# Images
				#
				# Note: When we add/remove links any alignment class needs to be
				# moved to either the link (on adding a link) or the image (on
				# removing a link). Alignment classes are mutually exclusive.
				alignmentClassNames = [
					'align-center',
					'align-left',
					'align-right'
					]

				if detail.href
                    element.a = {href: detail.href}

                    if element.a
                        element.a.class = element.a['class']

                    if detail.target
                        element.a.target = detail.target

                    for className in alignmentClassNames
                        if element.hasCSSClass(className)
                            element.removeCSSClass(className)
                            element.a['class'] = className
                            break

                else
                    linkClasses = []
                    if element.a['class']
                        linkClasses = element.a['class'].split(' ')
                    for className in alignmentClassNames
                        if linkClasses.indexOf(className) > -1
                            element.addCSSClass(className)
                            break
                    element.a = null

				element.unmount()
				element.mount()

			else
                # Text elements

				# Clear pseudo-select? I dunno.
				if element.content
                    # Remove the fake selection from the element
                    element.content = element.content.unformat(from, to, selectTag)

                # Clear any existing link
                element.content = element.content.unformat(from, to, 'a')

                # If specified add the new link
                if detail.href
                    a = new HTMLString.Tag('a', detail)
                    element.content = element.content.format(from, to, a)
                    element.content.optimize()

                element.updateInnerHTML()
                element.restoreState()

                ContentTools.Tools.Link.dispatchEditorEvent('tool-applied',toolDetail)
				
			# Make sure the element is marked as tainted
			element.taint()
			
			modal.hide()
			dialog.hide()
			
			callback(true)
			
		# Dispatch `applied` event
		@dispatchEditorEvent('tool-apply', toolDetail)
			
		app.attach(modal)
		app.attach(dialog)
		modal.show()
		dialog.show()

ContentTools.DEFAULT_TOOLS[0].push('custom-link')