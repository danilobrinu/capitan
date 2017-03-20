module SprintsHelper

  def select_sprint_page sprint_pages_ids, page_id
    return "" if sprint_pages_ids == nil
    sp = sprint_pages_ids.select { |sp| sp[0] == page_id }
    return !sp.empty? ? sp.first[1] : ""
  end

end
