<% if mapa_establecimientos.present? %>
	<% mapa_establecimientos.each do |me| %>
		<p>!-------NUEVO--------!</p>
		<p><%= me['departamento'] %></p> 
		<p><%= me['distrito'] %></p>
		<p><%= me['barrio_localidad'] %></p>
		<p><%= me['geojson'] %></p>
	<% end %>
<% else %>
	<p>Nada que mostrar</p>
<% end %>