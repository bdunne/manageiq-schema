class ReencryptPasswordScramsha < ActiveRecord::Migration[6.1]
  def up
    say_with_time('Reencrypting database user password with scram-sha-256') do
      database_yml = YAML.safe_load(Rails.root.join("config", "database.yml"))
      username = database_yml[Rails.env]["username"]
      password = MiqPassword.try_decrypt(database_yml[Rails.env]["password"])

      execute <<-SQL
        SET password_encryption='scram-sha-256';
      SQL

      execute <<-SQL
        ALTER ROLE #{username} WITH PASSWORD '#{password}';
      SQL
    end
  end
end
