define [
  "require"
  "jquery"
  "underscore"
],
(require, $, _) ->
  mermaid = d3 = null

  class NotebookMermaid
    constructor: -> require [@toUrl @mmp "mermaid.min.js"], @initDeps

    toUrl: (url) -> require.toUrl url

    mmp: (f) -> "./lib/mermaid/dist/#{f}"

    initDeps: (_m) =>
      mermaid = _m
      d3 = window.d3
      @initCSS()
      @initEnv()

    initCSS: ->
      d3.select "head"
        .selectAll "link.mermaid_style"
        .data ["mermaid.css", "mermaid.forest.css"].map @mmp
        .enter()
        .append "link"
        .attr
          rel: "stylesheet"
          href: @toUrl

    initEnv: ->
      require ["base/js/events"], @initNotebook, @initStatic

    initStatic: ->
      mermaid.init()

    initNotebook: (events) =>
      @initStatic()
      events.on "rendered.MarkdownCell", @markdownRendered

    markdownRendered: (evt, {cell}) ->
      mermaid.init undefined, cell.element.find ".mermaid"


  init = -> new NotebookMermaid

  init.load_ipython_extension = init