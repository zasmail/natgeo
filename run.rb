require 'byebug'
require 'open-uri'
require 'pp'
require 'nokogiri'
require 'progress_bar'
require 'json'
require 'algoliasearch'


def browse_algolia(index, cursor=nil)
  results = index.browse({
    query: "",
    hitsPerPage: 1000,
    cursor: cursor
  })
  if results['hits'].count < 1000
    push_updates(index, results['hits'])
  else
    push_updates(index, results['hits'])
    browse_algolia(index, cursor=results['cursor'])
  end
end

def push_updates(index, hits)
  updated_hits = hits.map do |hit|
    url = hit["objectID"]
    if url.split(".com/").length > 1
      hit["content_type"] = url.split(".com/")[1].split("/")[0]
    end
    hit
  end
  index.add_objects(updated_hits)
end

Algolia.init :application_id => "1Z1WHLLB4B",
             :api_key        => "e7dd89a82ee6089afb622d62e16e7790"
index = Algolia::Index.new("natgeo.tmp")

browse_algolia(index)
puts "Done :)"
