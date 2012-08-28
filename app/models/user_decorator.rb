User.class_eval do
  extend FriendlyId
  # For Refinery
  # accepts_nested_attributes_for :roles
  # attr_accessible :roles_attributes, :roles
  has_many :plugins, :class_name => "Refinery::UserPlugin", :order => "position ASC", :dependent => :destroy
  accepts_nested_attributes_for :plugins
  attr_accessible :plugins_attributes, :plugins
  friendly_id :login

  scope :refinery_admin, lambda { includes(:roles).where("#{roles_table_name}.name" => "Refinery") }

  has_many :plugins, :class_name => "::Refinery::UserPlugin", :order => "position ASC", :dependent => :destroy

  # Find user by email or username.
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign_in-using-their-username-or-email-address
  def self.find_for_database_authentication(conditions)
    value = conditions[authentication_keys.first]
    where(["login = :value OR email = :value", {:value => value}]).first
  end

  def plugins=(plugin_names)
    if persisted? # don't add plugins when the user_id is nil.
      ::Refinery::UserPlugin.delete_all(:user_id => id)

      plugin_names.each_with_index do |plugin_name, index|
        plugins.create(:name => plugin_name, :position => index) if plugin_name.is_a?(String)
      end
    end
  end

  def authorized_plugins
    plugins.collect { |p| p.name } | ::Refinery::Plugins.always_allowed.names
  end

  def add_role(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Spree::Role)
    spree_roles << Spree::Role[title] unless has_role?(title)
  end

  def has_role?(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Spree::Role)
    spree_roles.any?{ |r| r.name == title.to_s.camelize || r.name == title.to_s }
  end

  def can_edit?(user_to_edit = self)
    user_to_edit.persisted? && (
      user_to_edit == self ||
      self.has_role?(:superuser)
    )
  end

  def can_delete?(user_to_delete = self)
    user_to_delete.persisted? and
    id != user_to_delete.id and
    !user_to_delete.has_role?(:superuser) and
    Spree::Role.find_by_name(:refinery).users.count > 1
  end

  def title
    self.name
  end

  def create_first
    if valid?
      # first we need to save user
      save
      # add refinery role
      add_role(:refinery)
      # add superuser role
      add_role(:superuser) if ::Refinery::Role[:refinery].users.count == 1
      # add plugins
      self.plugins = Refinery::Plugins.registered.in_menu.names
    end

    # return true/false based on validations
    valid?
  end

  def username
    login
  end

  def username=(value)
    login = value
  end

  def to_s
    login.to_s
  end

  def to_param
    to_s.parameterize
  end


end
