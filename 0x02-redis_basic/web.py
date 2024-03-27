#!/usr/bin/env python3
'''A module for request caching and tracking using Redis.
'''
import redis
import requests
from functools import wraps
from typing import Callable


redis_store = redis.Redis()
'''The module-level Redis instance for request caching.
'''


def data_cacher(method: Callable) -> Callable:
    '''Decorator function to cache fetched data and track requests.
    '''
    @wraps(method)
    def invoker(url) -> str:
        '''Wrapper function to cache fetched data and track requests.
        '''
        redis_store.incr(f'count:{url}')
        result = redis_store.get(f'result:{url}')
        if result:
            return result.decode('utf-8')
        result = method(url)
        redis_store.set(f'count:{url}', 0)
        redis_store.setex(f'result:{url}', 10, result)
        return result
    return invoker


@data_cacher
def get_page(url: str) -> str:
    '''Retrieves the content of a URL after caching the response and tracking the request.
    '''
    return requests.get(url).text
