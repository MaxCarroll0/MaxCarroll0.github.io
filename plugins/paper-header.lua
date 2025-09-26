Plugin.require_version("4.0.0")

if not config["paper_header_template"] then
  Plugin.fail("paper_header_template option must be specified")
end

if not config["paper_pdf_template"] then
  Plugin.fail("paper_pdf_tempalte option must be specified")
end

if not config["content_container_selector"] then
  Plugin.fail("content_container_selector option must be specified")
end

content_container = HTML.select_one(page, config["content_container_selector"])
if not content_container then
  Log.warning(format("Page does not have an element matching the \"%s\" content container selector"),
    config["content_container_selector"])
  Plugin.exit()
end

-- The goal of this plugin is to produce uniform post headers
-- from custom <post-title>, <post-date>, <post-tags>, and <post-excerpt> elements
--

env = {}

function clean_up(x)
  HTML.delete(x)
end

-- TODO: De-deuplicate code

-- Extract and clean up the <paper-title> element
paper_title = HTML.select_one(page, "paper-title")
env["title"] = HTML.inner_html(paper_title)
clean_up(paper_title)

-- Extract and clean up the <paper-date> element
paper_date = HTML.select_one(page, "paper-date")
env["date"] = HTML.inner_html(paper_date)
clean_up(paper_date)

-- Utilities
function trim_list(lst)
  Table.apply_to_values(String.trim, lst)
  return lst
end

function split_on_comma(str)
    return trim_list(Regex.split(str, ","))
end


function split_on_bar(str)
    return trim_list(Regex.split(str, "\\|"))
end


-- Extract and clean up the <paper-authors> element
-- It's supposed to look like <paper-authors>name| url, name2| url2</paper-authors>
-- We extract the author names and urls split it into individual pairs
paper_authors = HTML.select_one(page, "paper-authors")
authors = HTML.strip_tags(paper_authors)
authors = split_on_comma(authors)
Table.apply_to_values(split_on_bar, authors)
env["authors"] = authors
clean_up(paper_authors)

-- Extract and clean up the <paper-artifacts> element
-- It's supposed to look like <paper-artifacts>name: url, name2: url2</paper-artifacts>
-- We extract the artifact types and values split it into individual pairs
paper_artifacts = HTML.select_one(page, "paper-artifacts")
artifacts = HTML.strip_tags(paper_artifacts)
artifacts = split_on_comma(artifacts)
Table.apply_to_values(split_on_bar, artifacts)
env["artifacts"] = artifacts
clean_up(paper_artifacts)

-- Extract and clean up the <paper-keywords> element
-- It's supposed to look like <paper-keywords>keyword1, keyword2</paper-keywords>
-- We extract the tags string and split it into individual keywords
paper_keywords = HTML.select_one(page, "paper-keywords")
keywords = HTML.strip_tags(paper_keywords)
keywords = split_on_comma(keywords)
env["keywords"] = keywords
clean_up(paper_keywords)


--- Handle the <paper-abstract>
paper_abstract = HTML.select_one(page, "paper-abstract")
env["abstract"] = HTML.inner_html(paper_abstract)
clean_up(paper_abstract)

--- Handle the <paper-pages>
paper_pages = HTML.select_one(page, "paper-pages")
env["pages"] = HTML.inner_html(paper_pages)
clean_up(paper_pages)

--- Handle the <paper-pdf>
paper_pdf_path = HTML.select_one(page, "paper-pdf")
env["pdf_path"] = HTML.inner_html(paper_pdf_path)
clean_up(paper_pdf_path)

--- Handle the <paper-conference>name, url</paper-conference>
paper_conference = HTML.select_one(page, "paper-conference")
conference = HTML.strip_tags(paper_conference)
conference = split_on_comma(conference)
env["conference"] = conference[1]
env["conference_url"] = conference[2]
clean_up(paper_conference)

-- Now clean up the <post-metadata> container
post_metadata_container = HTML.select_one(page, "paper-metadata")
if post_metadata_container then
    HTML.delete(post_metadata_container)
end

-- Render the paper header and add it to the page
tmpl = config["paper_header_template"]
tmpl_pdf = config["paper_pdf_template"]
header = HTML.parse(String.render_template(tmpl, env))
footer = HTML.parse(String.render_template(tmpl_pdf, env))
HTML.prepend_child(content_container, header)
HTML.append_child(content_container, footer)
