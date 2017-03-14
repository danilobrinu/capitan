module ProfileHelper
  def age(user)
    "#{user.age} años" unless user.age.nil?
  end

  def district(user)
    user.district.blank? ? 'Lima' : user.district
  end

  def biography(user)
    user.profile.biography.blank? ? 'Soy un estudiante en Laboratoria' : user.profile.biography
  end

  def percent(scored, total)
    if scored != nil and total != nil
      percent = (scored.zero? or total.zero?) ? 0 : (scored / total.to_f) * 100
    else
      percent = 0
    end
  end

  def zero_or_number(points)
    points.to_i
  end
end
