class CustomCreateTool extends ContentTools.Tools.Link

	#Register
	ContentTools.ToolShelf.stow(@, 'custom-create');

	#Config
	@label = 'Create Page'
	@icon = 'create'
	@tagName = 'a'

	@canApply: (element, selection) ->
		if (!ContentTools.PAGE_UPLOADER) 
			return false
		if (!selection || selection.isCollapsed())
			return false
		if (!element.content || element.content.length == 0)
			return false

		[from, to] = selection.get()
		if from == to
			to += 1
			
		return !element.content.slice(from, to).hasTags(@tagName, true)

	@apply: (element, selection, callback) ->
		# Dispatch `apply` event
		toolDetail = {
            'tool': this,
            'element': element,
            'selection': selection
            }

		if not @dispatchEditorEvent('tool-apply', toolDetail)
            return

		# Get Text
		[from, to] = selection.get()
		selectedString = ''
		while from <= to
			selectedString += element.content.characters[from]._c
			from++
		
		# Start PAGE_UPLOADER listening
		ContentTools.PAGE_UPLOADER(this).Create(selectedString)

		#save state
		element.storeState()
		@element = element
		@selection = selection
		@callback = callback
		
		# Dispatch `applied` event
		@dispatchEditorEvent('tool-apply', toolDetail)
		
		# Make sure the element is marked as tainted
		@element.taint()
		@callback(true)
	
	@populate: (href) ->
		[from, to] = @selection.get()

		#create anchor tag
		a = new HTMLString.Tag('a', { href: href })
		@element.content = @element.content.format(from, to, a)
		@element.content.optimize()
		
		@element.updateInnerHTML()
		@element.restoreState()

ContentTools.DEFAULT_TOOLS[0].push('custom-create')