using BSMS.BusinessLayer.Commands;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/customers")]
    public class CustomersController : ControllerBase
    {
        private readonly IMediator _mediator;

        public CustomersController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // POST api/customers/register
        [HttpPost("register")]
        public async Task<IActionResult> RegisterCustomer(CreateCustomerCommand command)
        {
            var keycloakId = await _mediator.Send(command);

            return CreatedAtAction(nameof(GetCustomerByKeycloakId), new { keycloakId }, command);
        }

        [HttpPost("address")]
        public async Task<IActionResult> AddCustomerAddress(CreateCustomerAddressCommand command)
        {
            return Ok(await _mediator.Send(command));

        }

        [HttpPost("preferences")]
        public async Task<IActionResult> CreateCustomerPreferences(CreateCustomerPreferenceCommand command)
        {
            return Ok(await _mediator.Send(command));

        }

    }
}
