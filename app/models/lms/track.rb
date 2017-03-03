# == Schema Information
#
# Table name: tracks
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  description       :text(65535)
#  syllabus          :string(255)
#  color             :string(255)
#  icon_file_name    :string(255)
#  icon_content_type :string(255)
#  icon_file_size    :integer
#  icon_updated_at   :datetime
#  sequence          :integer
#

class Track < ActiveRecord::Base
  has_many :courses
  has_many :enrollments, :dependent => :destroy
  has_many :users, through: :enrollments

  accepts_nested_attributes_for :enrollments

  has_attached_file :icon,
                    :styles => { :normal => "94x94", :responsive => "56x56" },
                    :url => "/system/:class/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/:class/:id/:style/:basename.:extension"

  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/

  def self.available_tracks(user)
    Track.joins(:enrollments).where(" enrollments.user_id = ? and enrollments.status = 1", user.id)
  end

  def duration
    query = "select sum(duration) from units u join courses c on u.course_id = c.id join tracks t on c.track_id = t.id where t.id = #{self.id}"
    ActiveRecord::Base.connection.execute(query).first[0]
  end

  def teachers branch
    branch_name = branch.name.upcase
    puts branch_name
    teachers = []
    case branch_name
      when "LIMA"
        if self.name == "User Experience Design"
        teachers = [ {name: "Lalo Gonzalez", image: "teachers/lima/lalo.jpg", title: "UX Designer", mail: "lalo@laboratoria.la"},
                     {name: "Jordi Tambillo", image: "teachers/lima/jordi.jpg", title: "Interaction Designer", mail: "jordi@laboratoria.la"}]
        # elsif self.name == "JavaScript"
        # teachers = [ {name: "John", image: "teachers/lima/gian.jpg", title: "Full Stack Developer", mail: "john@laboratoria.la"},
        #              {name: "Elizabeth Portilla", image: "teachers/lima/elizabeth.jpg", title: "Full Stack Developer", mail: "elizabeth@laboratoria.la"},
        #              {name: "Lupo", image: "teachers/lima/ivan.jpg", title: "Full Stack Developer", mail: "lupo@laboratoria.la"}]

        else
        teachers = [ {name: "Giancarlo Corzo", image: "teachers/lima/gian.jpg", title: "Full Stack Developer", mail: "gian@laboratoria.la"},
                     {name: "Elizabeth Portilla", image: "teachers/lima/elizabeth.jpg", title: "Full Stack Developer", mail: "elizabeth@laboratoria.la"},
                     {name: "Iván Medina", image: "teachers/lima/ivan.jpg", title: "Back End Developer", mail: "ivan@laboratoria.la"}]
        end
      when "MéXICO"
        teachers = [ {name: "Grissel Rocha", image: "teachers/mexico/grissel.jpg", title: "Full Stack Developer", mail: "grissel@laboratoria.mx"} ]
      when "CHILE"
        teachers = [ {name: "Blanca Pérez", image: "teachers/chile/blanca.jpg", title: "Full Stack Developer", mail: "blanca@laboratoria.cl"}]
      when "AREQUIPA"
        teachers = [ {name: "Gerson Aduviri", image: "teachers/arequipa/gerson.jpg", title: "Full Stack Developer", mail: "gerson@laboratoria.la"} ]
    end
  end
end
