<template>
  <div>
    <p v-if='errors.length > 0'>{{errors}}</p>
    <form id='tournament' v-on:submit.prevent>
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
          <option v-for="game in games" :value="game.id">
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
      <button @click='sendTournament()'>{{buttonText}}</button>
    </form>
  </div>
</template>

<script>
  import api from '../api'
  export default {
    name: 'TournamentForm',
    props: {
      buttonText: String,
      tournament: {}
    },
    data () {
      return {
        errors: '',
        games: []
      }
    },
    mounted () {
      api.getGames().then(response => {
        this.games = response.data
      })
    },
    methods: {
      sendTournament () {
        if (this.$route.name === 'tournamentNew') {
          this.$store.dispatch('addTournament', this.tournament)
        } else if (this.$route.name === 'tournamentUpdate') {
          this.$store.dispatch('updateTournament', this.tournament)
        }
        this.errors = this.$store.state.errors
      }
    }
  }
</script>

<style scoped>
  #tournament {
    text-align: left;
  }
</style>
