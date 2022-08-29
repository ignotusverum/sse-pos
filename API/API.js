const express = require('express')
const date = require('date-and-time')

const headers = {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive'
}

const app = express()
app.use(express.static('public'))

app.get('/countdown', function (req, res) {
    res.writeHead(200, headers)
    countdown(res, 120)
})

function countdown(res, count) {
    const message = { rawValue: `SSE MVC: ${date.format(new Date(), 'HH:mm:ss')}` }
    res.write(JSON.stringify(message))
    if (count)
        setTimeout(() => countdown(res, count - 1), 1000)
    else
        res.end()
}

app.listen(3000, () => console.log('SSE app listening on port 3000'))