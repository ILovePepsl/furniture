ActiveAdmin.register_page "Dashboard" do
  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Добавьте свои секции здесь, например, простая панель:
    panel "Recent Products" do
      ul do
        Product.recent(5).map do |product|
          li link_to(product.name, admin_product_path(product))
        end
      end
    end
  end
end
