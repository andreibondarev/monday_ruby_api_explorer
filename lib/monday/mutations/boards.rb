class Monday::Mutations::Boards < Monday::HttpRequest
  def add_board(params = {})
    raise KeyError, "Missing 'board_name' parameter" unless params.fetch(:board_name)
    raise KeyError, "Missing 'board_kind' parameter" unless params.fetch(:board_kind)

    request = create_new_board_request(params)

    request(request, :post)
  end

  def find(board_id)
    raise KeyError, "Missing 'board_id' parameter" unless board_id

    request = {
      'query': "query {
        boards (ids: #{board_id}){
          id
          name
          description
          state
          columns {
            id
            title
            type
            archived
            description
            settings_str
            width
          }
          items {
            id
            name
            state
            created_at
            updated_at
            column_values {
              additional_info
              id
              text
              title
              type
              value
              description
            }
          }
        }
      }"
    }

    response = request(request, :post)
    response.dig('data', 'boards').first
  end

  def list
    request = {
      'query': "query {
        boards {
          id
          name
          state
          board_folder_id
          board_kind
        }
      }"
    }

    response = request(request, :post)
    response.dig('data', 'boards')
  end

  def archive_board(board_id)
    raise KeyError, "Missing 'board_id' parameter" unless board_id

    request = {
      'query': "mutation { archive_board (board_id: #{board_id}) { id } }"
    }

    request(request, :post)
  end

  private

  def create_new_board_request(req)
    if req[:workspace_id] || req[:template_id]
      create_new_board_request_with_options(req)
    end

    {
      'query' => "mutation { create_board (board_name: \"#{req[:board_name]}\", board_kind: #{req[:board_kind]}) { id } }" 
    }
  end

  def create_new_board_request_with_options(req)
    if req[:workspace_id] && !req[:template_id]
      {
        'query' => "mutation { create_board (
          board_name: \"#{req[:board_name]}\", 
          board_kind: #{req[:board_kind]},
          workspace_id: #{req[:workspace_id]}
          ) { id } }" 
      }
    end

    if req[:template_id] && !req[:workspace_id]
      {
        'query' => "mutation { create_board (
          board_name: \"#{req[:board_name]}\", 
          board_kind: #{req[:board_kind]},
          template_id: #{req[:template_id]}
          ) { id } }" 
      }
    end

    if req[:template_id] && req[:workspace_id]
      {
        'query' => "mutation { create_board (
          board_name: \"#{req[:board_name]}\", 
          board_kind: #{req[:board_kind]},
          workspace_id: #{req[:workspace_id]},
          template_id: #{req[:template_id]}
          ) { id } }" 
      }
    end
  end
end