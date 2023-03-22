class Monday::Boards
  def create(params)
    Monday::Mutations::Boards.new.add_board(params)
  end

  def find(board_id)
    Monday::Mutations::Boards.new.find(board_id)
  end

  def archive(board_id)
    Monday::Mutations::Boards.new.archive_board(board_id)
  end

  def list
    Monday::Mutations::Boards.new.list
  end

  def subscribers
    Monday::Mutations::Boards::Subscribers.new
  end
end