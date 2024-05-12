#ActiveAdmin.register AdminUser do
# permit_params :email, :password, :password_confirmation
#
# index do
#   selectable_column
#   id_column
#   column :email
#   column :current_sign_in_at
#   column :sign_in_count
#   column :created_at
#   actions
# end
#
# filter :email
# filter :current_sign_in_at
# filter :sign_in_count
# filter :created_at
#
# form do |f|
#   f.inputs 'Admin Details' do
#     f.input :email
#     f.input :password
#     f.input :password_confirmation
#   end
#   f.actions
# end
#
# controller do
#   def update
#     if params[:admin_user][:password].blank?
#       params[:admin_user].delete("password")
#       params[:admin_user].delete("password_confirmation")
#     end
#     super
#   end
#
#   def create
#     @admin_user = AdminUser.new(permitted_params[:admin_user])
#       redirect_to admin_admin_user_path(@admin_user), notice: "Admin user was successfully created."
#     else
#    end
#  end
# end
# end