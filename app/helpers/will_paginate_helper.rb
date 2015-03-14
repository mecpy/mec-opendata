module WillPaginateHelper
  class WillPaginateAjaxLinkRenderer < WillPaginate::ActionView::LinkRenderer
    def prepare(collection, options, template)
      options[:params] ||= {}
      options[:params]["_"] = nil
      super(collection, options, template)
    end

    protected
    def link(text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = rel_value(target)
        target = url(target)
      end
      target = target.sub('/data', "") if Rails.env == "production" 
      ajax_call = "$.ajax({url: '#{target}', dataType: 'script'});return false;"
      @template.link_to(text.to_s.html_safe,"#", onclick: ajax_call)
    end
  end

  def ajax_will_paginate(collection, options = {})
    will_paginate(collection, options.merge(:renderer => WillPaginateHelper::WillPaginateAjaxLinkRenderer))
  end
end
