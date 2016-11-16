<template>
  <div>
    <form id='tournament'>
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
      <button type='button' @click='sendTournament()'>{{buttonText}}</button>
    </form>
  </div>
</template>

<script>
  export default {
    name: 'TournamentForm',
    props: {
      buttonText: {
        type: String
      },
      tournament: {
        type: Object
      }
    },
    computed: {
      games () {
        return this.$store.getters.games
      }
    },
    methods: {
      sendTournament () {
        if (this.$route.name === 'tournamentNew') {
          this.$store.dispatch('addTournament', this.tournament)
        } else if (this.$route.name === 'tournamentUpdate') {
          this.$store.dispatch('updateTournament', this.tournament)
        }
      }
    }
  }
</script>

<style scoped>
  #tournament {
    text-align: left;
  }
</style>
