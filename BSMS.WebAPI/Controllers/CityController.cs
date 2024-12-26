using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CitiesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public CitiesController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllCities()
        {
            return Ok(await _mediator.Send(new GetAllCitiesQuery()));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCityById(int id)
        {
            return Ok(await _mediator.Send(new GetCityByIdQuery { CityId = id }));
        }
    }
}
