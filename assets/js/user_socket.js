import {Socket} from "phoenix"
let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel
    .join()
    .receive("ok", resp => { 
      renderComments(resp.comments)
    })
    .receive("error", resp => { 
      console.log("Unable to join", resp)
    })
  
  channel.on(`comments:${topicId}:new`, renderComment)

  document.querySelector('button').addEventListener('click', () =>{
    const content = document.querySelector('textarea').value

    channel.push('comment:add', { content: content })
  })
}

function renderComments(comments) {
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment)
  })

  document.querySelector('.collection').innerHTML = renderedComments.join('')
}

function renderComment(event) {
  const renderComment = commentTemplate(event.comment)

  document.querySelector('.collection').innerHTML += renderComment
}

function commentTemplate(comment) {
  return `
  <li class="collection-item">
    ${comment.content}
  </li>
`
}

window.createSocket = createSocket 