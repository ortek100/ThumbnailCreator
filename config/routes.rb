Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'thumbnail' => 'thumbnail#thumbnail_create'
  get '*path' => redirect('/')

end
