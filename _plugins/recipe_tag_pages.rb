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
      # Group by slug so case variants ("Dessert" vs "dessert")
      # don't generate duplicate tags/<slug>/index.html pages.
      variants_by_slug = Hash.new { |h, k| h[k] = Hash.new(0) }
      (site.collections['recipes']&.docs || []).each do |recipe|
        raw = recipe.data['tags']
        next unless raw

        # Handle both "Chicken, Asian" strings and ["Chicken", "Asian"] arrays
        Array(raw).flat_map { |t| t.to_s.split(',') }.each do |tag|
          clean = tag.strip
          next if clean.empty?

          slug = Jekyll::Utils.slugify(clean)
          next if slug.empty?

          variants_by_slug[slug][clean] += 1
        end
      end

      variants_by_slug.each do |_slug, variants|
        # Prefer most frequent variant; tie-break toward capitalized form.
        canonical = variants.max_by { |tag, count| [count, tag =~ /\A[A-Z]/ ? 1 : 0] }.first
        site.pages << RecipeTagPage.new(site, site.source, canonical)
      end
    end
  end
end
