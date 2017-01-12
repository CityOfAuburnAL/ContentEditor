class CustomLinkTool extends ContentTools.Tools.Link

	#Register
	ContentTools.ToolShelf.stow(@, 'custom-link');

	#Config
	@label = 'Custom Link'
	@icon = 'link'
	@tagName = 'a'

ContentTools.DEFAULT_TOOLS[0].push('custom-link')