module Users
  module UserSearch
    def updatable_id
      "users-list"
    end

    SELECT_FIELDS = [
      'users.id as id,' \
      'users.name as name,' \
      'users.email as email,' \
      'roles.name as role_name,' \
      'roles.id as role_id,' \
      'users.discarded_at as discarded_at'
    ].freeze

    def select_fields
      select(SELECT_FIELDS)
    end

    def search_from
      from(table_name).joins(:role)
    end

    def search_fields
      {
        id: { condition_type: :exact, type: :number },
        name: { condition_type: :like },
        email: { condition_type: :like },
        role_id: { condition_type: :exact,
                   tag: :select,
                   values: roles_list },
        discarded_at: { condition_type: :range,
                        type: "datetime-local",
                        range: true }
      }
    end

    def roles_list
      {
        Role::ADMIN_ID => Role::ADMIN_NAME.capitalize,
        Role::MODERATOR_ID => Role::MODERATOR_NAME.capitalize
      }
    end
  end
end
