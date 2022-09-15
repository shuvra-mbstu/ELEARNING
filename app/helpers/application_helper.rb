module ApplicationHelper
  def humanize(model, count = 1)
    model.model_name.human(count: count)
  end

  def date_parses(date)
    Date.parse(date.to_s)
  end
end
