require 'set'

module Jekyll
  class RecipeTagPage < Page
    def initialize(site, base, tag)
      @site  = site
      @base  = base
      @dir   = File.join('tags', Jekyll::Utils.slugify(tag))
      @name  = 'index.html'
      process(@name)
      read_yaml(File.join(base, '_layouts'), 'tag.html')
      data['tag']    = tag
      data['title']  = tag
      data['layout'] = 'tag'
    end
  end

  class RecipeTagPageGenerator < Generator
    safe true

    def generate(site)
      tags = Set.new
      (site.collections['recipes']&.docs || []).each do |recipe|
        raw = recipe.data['tags']
        next unless raw
        # Handle both "Chicken, Asian" strings and ["Chicken", "Asian"] arrays
        Array(raw).flat_map { |t| t.to_s.split(',') }.each do |tag|
          clean = tag.strip
          tags.add(clean) unless clean.empty?
        end
      end

      tags.each { |tag| site.pages << RecipeTagPage.new(site, site.source, tag) }
    end
  end
end
