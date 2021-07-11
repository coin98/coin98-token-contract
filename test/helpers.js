const PREFIX = 'Returned error: VM Exception while processing transaction:';

async function tryCatch(promise, message, userMessage) {
  try {
    await promise
    throw null
  }
  catch (error) {
    assert(error, 'Expected an error but did not get one')
    const prefx = `${PREFIX} ${message}`
    assert(error.message.startsWith(prefx), `Expected an error starting with \'${prefx}\' but got \'${error.message}\' instead.`)
    if (userMessage) {
      const subMessage = error.message.substr(prefx.length + 1)
      assert(error.message === `${PREFIX} ${message} ${userMessage}`, `Expected validation error \'${userMessage}\' but got \'${subMessage}\' instead.`)
    }
  }
}

module.exports = {
  catchRevert: async function(promise, userMessage) {
    await tryCatch(promise, 'revert', userMessage)
  },
  catchOutOfGas: async function(promise) {
    await tryCatch(promise, 'out of gas')
  },
  catchInvalidJump: async function(promise) {
    await tryCatch(promise, 'invalid JUMP')
  },
  catchInvalidOpcode: async function(promise) {
    await tryCatch(promise, 'invalid opcode')
  },
  catchStackOverflow: async function(promise) {
    await tryCatch(promise, 'stack overflow')
  },
  catchStackUnderflow: async function(promise) {
    await tryCatch(promise, 'stack underflow')
  },
  catchStaticStateChange: async function(promise) {
    await tryCatch(promise, 'static state change')
  }
}
