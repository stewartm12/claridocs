class Quality::MarkdownRenderer
  # Custom renderer for better code block handling
  class CustomRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      language_class = language ? " class=\"language-#{language}\"" : ''
      "<pre class=\"code-block\"><code#{language_class}>#{html_escape(code)}</code></pre>"
    end

    def codespan(code)
      "<code class=\"inline-code\">#{html_escape(code)}</code>"
    end

    private

    def html_escape(text)
      text.gsub('&', '&amp;')
          .gsub('<', '&lt;')
          .gsub('>', '&gt;')
          .gsub('"', '&quot;')
          .gsub("'", '&#39;')
    end
  end

  # Initialize once and reuse the parser
  RENDERER = CustomRenderer.new(
    filter_html: false,           # Don't filter HTML since we're controlling it
    no_intra_emphasis: true,      # Don't parse emphasis inside words
    hard_wrap: false,             # DON'T convert newlines to <br> - this was causing issues
    autolink: true,               # Auto-link URLs
    prettify: true,               # Add prettyprint classes
    safe_links_only: true,        # Only allow safe link protocols
    with_toc_data: true           # Add anchors to headers
  )

  PARSER = Redcarpet::Markdown.new(
    RENDERER,
    autolink: true,               # Auto-link URLs and email addresses
    tables: true,                 # Parse tables
    fenced_code_blocks: true,     # Parse ```code``` blocks
    strikethrough: true,          # Parse ~~strikethrough~~
    superscript: true,            # Parse ^superscript^
    underline: true,              # Parse _underline_ (if not emphasis)
    highlight: true,              # Parse ==highlight==
    quote: true,                  # Parse "smart quotes"
    footnotes: true,              # Parse footnotes
    no_intra_emphasis: true,      # Don't parse _emphasis_ inside words
    space_after_headers: true     # Require space after # for headers
  )

  def initialize(file_path)
    @file_path = Rails.root.join(file_path)
  end

  def render
    return 'File not found' unless File.exist?(@file_path)

    content = File.read(@file_path)

    # Render markdown to HTML
    PARSER.render(content)
  end
end
