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

	ajaxProcess: (url, method, callback, data) =>
		{ form } = @state
		$.ajax(
			type: method
			beforeSend: (xhr, e) =>
				xhr.setRequestHeader('X-XFERS-USER-API-KEY', "#{form?.token}")
				@onChangeItem('change_item',form, null, 'initialLoaded', false)
			url: url
			crossDomain: true
			xhrFields: {withCredentials: true}
			cache: false
			data: if data != null then JSON.stringify(data) else null
			async: true
			contentType: 'application/json'
			dataType: 'json'
			success: (data) =>
				@onChangeItem('change_item',form, null, 'initialLoaded', true)
				if url.match(/transfer_info/i)
					@onChangeItem('change_item',form, null, 'transferInfo', data)
				else if url.match(/charges/i)
					debugger
					@onChangeItem('change_item',form, null, 'chargesInfo', data)
				else
					console.log data
					@onChangeItem('change_item',form, null, 'userInfo', data)
			error: (e, xhr, i) =>
				debugger
				alert(e.error)
		).done((e) =>
			if typeof callback == 'function'
				callback()
		)

	onInitialLoad: ->
		{ form } = @state
		# debugger

		setTimeout((e) =>
			@ajaxProcess(form.urls.userInfo.url, form.urls.userInfo.method, @ajaxProcess(form.urls.transferInfo.url, form.transferInfo.method))
		,1500)

	onChangeTab: (item) =>
		{ form } = @state
		@onChangeItem('change_item',form, null, 'initialLoaded', false)
		setTimeout((e) =>
			@onChangeItem('change_item',form, null, 'initialLoaded', true)
			@onChangeItem('change_item',form, null, 'activePage', item)
		,1500)

	onAddLists: (item, page) =>
		{ form } = @state
		@onChangeTab(page)
		postData =
			debit_only: true
			amount: item?.amount
			currency: 'IDR'
			order_id: '3433'
		@ajaxProcess(form.urls.createCharges.url, form.urls.createCharges.method, null, postData)


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
					balance: {Number(form?.userInfo?.available_balance).toFixed(2)}
					<hr/>
					{
						if form?.activePage == 'default'
							<div>
								<h2>welcome</h2>
								<div>you have success</div>
								<div>you can top up</div>
								<div>
									<span>Bank Name: {form?.transferInfo?.bank_name_full}</span>
									<br/>
									<span>Account Number: {form?.transferInfo?.bank_account_no}</span>
									<br/>
									<span>Unique ID: {form?.transferInfo?.unique_id}</span>
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
