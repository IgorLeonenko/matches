<template>
  <div>
    <h1>New tournament</h1>
    <p v-if='error'>{{error}}</p>
    <form id='new-tournament'>
      <p>
        <label for='title'>Title</label>
        <input type='text' v-model='tournament.title' name='title'></input>
      </p>
      <p>
        <label for='description'>Description</label>
        <textarea v-model='tournament.description' name='description'></textarea>
      </p>
      <p>
        <label for='game'>Choose game</label>
        <select v-model='tournament.game_id'>
          <option v-for="game in games" v-bind:value="game.id">
            {{ game.name }}
          </option>
        </select>
      </p>
      <p>
        <label for='picture'>Image</label>
        <input type="text" v-model='tournament.picture' name="picture"></input>
      </p>
      <p>
        <label for='date'>Start date</label>
        <input type="date" v-model='tournament.start_date' name="date"></input>
      </p>
      <p>
        <label for='teams_quantity'>Teams quantity</label>
        <input type="number" v-model='tournament.teams_quantity'
               name="teams_quantity"></input>
      </p>
      <p>
        <label for='players_in_team'>Players in team</label>
        <input type="number" v-model='tournament.players_in_team'
               name="players_in_team">
        </input>
      </p>
      <button @click='submit()'>Create tournament</button>
    </form>
  </div>
</template>

<script>
import api from '../api'
export default {
  name: 'NewTournament',
  data () {
    return {
      error: '',
      games: [],
      tournament: {
        title: '',
        description: '',
        game_id: '',
        picture: '',
        start_date: '',
        teams_quantity: 0,
        players_in_team: 0,
        style: 'deathmatch',
        creator_id: JSON.parse(localStorage.user).id.toString()
      }
    }
  },
  created () {
    api.getGames().then(response => {
      this.games = response.data
    })
  },
  methods: {
    submit () {
      api.createTournament(this.tournament).then(response => {
        console.log(response.data)
      }).catch(error => {
        console.log(error)
      })
    }
  }
}
</script>

<style scoped>
  #new-tournament {
    text-align: left;
  }
</style>
