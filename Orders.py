from DWX_ZeroMQ_Connector_v2_0_1_RC8 import DWX_ZeroMQ_Connector
import zmq


_zmq = DWX_ZeroMQ_Connector()


def subscribeToEurUsd():
    _zmq._DWX_MTX_SUBSCRIBE_MARKETDATA_('EURUSD')
    _zmq._Market_Data_DB

def unsubscribe():
    _zmq._DWX_MTX_UNSUBSCRIBE_ALL_MARKETDATA_REQUESTS_()

def marketData():
    _zmq._DWX_MTX_SEND_MARKETDATA_REQUEST_()
    _zmq._Market_Data_DB

def buy():
    _my_trade = _zmq._generate_default_order_dict()
    _my_trade['_type'] = 0 #buy = 0
    _my_trade['_lots'] = 0.01
    _my_trade['_SL'] = 100
    _my_trade['_TP'] = 200
    _my_trade['_symbol'] = 'EURUSD'
    _zmq._DWX_MTX_NEW_TRADE_(_order=_my_trade)

    #_zmq._DWX_ZMQ_Poll_Data_()
    #_zmq.remote_recv(zmq.Context().socket(zmq.SUB))

def sell():
    _my_trade = _zmq._generate_default_order_dict()
    _my_trade['_type'] = 1 #sell = 1
    _my_trade['_lots'] = 0.01
    _my_trade['_SL'] = 100
    _my_trade['_TP'] = 200
    _my_trade['_symbol'] = 'EURUSD'
    _zmq._DWX_MTX_NEW_TRADE_(_order=_my_trade)

def doNothing():
    return None

def getAllTrades():
    _zmq._DWX_MTX_GET_ALL_OPEN_TRADES_()

def closeAllTrades():
    _zmq._DWX_MTX_CLOSE_ALL_TRADES_()
