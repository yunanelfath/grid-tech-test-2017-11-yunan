React = require('react')
ReactDOM = require('react-dom')
GeneralStore = require('./store.cjsx')
AppDispatcher = require('./dispatcher.cjsx')
ReactBootstrap = require('react-bootstrap')
{ Jumbotron, FormGroup, HelpBlock, FormControl, ControlLabel, Alert} = ReactBootstrap
Loader = require('react-loader')
$ = require('jquery')
axios = require('axios')

{ Component } = React

class Wrapper extends Component
	constructor: (props) ->
		super(props)
		@state = {
			form: GeneralStore.form
		}

	componentDidMount: ->
		@listener = GeneralStore.addChangeListener(@_onChange.bind(@)) # this/@ should bind manuallyy
		@onInitialLoad()

	onInitialLoad: ->
		{ form } = @state
		# debugger
		setTimeout((e) =>
			@onChangeItem('change_item',form, null, 'initialLoaded', true)
			@onChangeItem('change_item',form, null, 'userInfo', JSON.parse(form.userInfo))
		,1500)

		$.ajax(
			type: form.urls.userInfo.method
			beforeSend: (xhr, e) =>
				xhr.setRequestHeader('X-XFERS-USER-API-KEY', "#{form?.token}")
				xhr.setRequestHeader('Access-Control-Allow-Origin', "origin")
				xhr.setRequestHeader('Access-Control-Allow-Credentials', 'true')
			url: form.urls.userInfo.url
			crossDomain: true
			xhrFields: {withCredentials: true}
			cache: false
			async: true
			contentType: 'application/json'
			dataType: 'json'
			success: (data) =>
				console.log data
			error: (e, xhr, i) =>
				console.log e
		).done((e) =>
			console.log e
		).fail((e) =>
			console.log e
		)

	onChangeTab: (item) =>
		{ form } = @state
		@onChangeItem('change_item',form, null, 'initialLoaded', false)
		setTimeout((e) =>
			@onChangeItem('change_item',form, null, 'initialLoaded', true)
			@onChangeItem('change_item',form, null, 'activePage', item)
		,1500)

	onAddLists: (item, page) =>
		{ form } = @state
		@onChangeItem('change_item',form, null, 'initialLoaded', false)
		setTimeout((e) =>
			@onChangeItem('change_item',form, null, 'initialLoaded', true)
			@onChangeItem('change_item',form, null, 'activePage', page)
		,1500)


	componentWillUnmount: ->
		@listener.remove()

	_onChange: ->
		@setState(
			form: GeneralStore.form
		)

	dispatchEvent: (attributes, actionType) =>
		# register action into dispatcher
		AppDispatcher.dispatch(
		  actionType: if actionType then actionType else 'route_action'
		  attributes: attributes
		)

	onChangeItem: (todo, item, children, key, event) =>
		if event == undefined
			attributes = toDo: todo, attributes: {parent: item, children: children}
			attributes
		else
			form = {}
			form[key] = if event?.target?.value || event?.target?.value == '' then event.target.value else event
			if event?.target?.type == 'checkbox'
				form[key] = event.target.checked
			attributes = toDo: todo, attributes: {parent: item, children: children, form: form}
			attributes

		@dispatchEvent(attributes)

	render: ->
		{ form } = @state

		<div className="container-fluid text-center">
			<div className="jumbotron">
				<Loader loaded={form?.initialLoaded}>
					<a href="#" onClick={@onChangeTab.bind(@, 'default')}>default</a><br/>
					<a href="#" onClick={@onChangeTab.bind(@, 'lists')}>my shop</a><br/>
					<a href="/tech-test/dist/">Exchange Rates converter</a>
					<hr/>
					{
						if form?.activePage == 'default'
							<div>
								<h2>welcome</h2>
								<div>you have success</div>
								<div>you can top up</div>
								<div>
									<span>Bank Name: {form?.userInfo?.nationality}</span>
									<br/>
									<span>Account Number: {form?.userInfo?.nationality}</span>
									<br/>
									<span>Unique ID: {form?.userInfo?.nationality}</span>
									<br/>
								</div>
							</div>
						else if form?.activePage == 'lists'
							itemRow = (e, index) =>
								<div key={index}>
									<a href="#" onClick={@onAddLists.bind(@, e, 'purchased')}>
										<span>Name: {e?.name}</span>
										<br/>
										<span>price: {e?.amount}</span>
										<br/>
									</a>
									<hr/>
								</div>
							<div>
								{
									form?.itemLists.map(itemRow)
								}
							</div>
						else
							<div>purchased kindle</div>

					}
				</Loader>
			</div>
		</div>

module.exports = Wrapper
