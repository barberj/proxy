json.versions @versions do |version|
  json.url version[:url]
  json.version version[:label]
end
